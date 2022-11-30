library(sparklyr)
library(dplyr)

config <- spark_config()
config["sparklyr.shell.driver-memory"] <- "16g"
config["spark.memory.fraction"] <- 0.8

sc <- spark_connect(master="local", config=config)
# spark_disconnect(sc)

n <- 1e7
p <- 1e3
id <- sdf_len(sc, n, repartition = 1000) %>%
  compute(name="id")
Xs <- paste(sprintf("rand() * 2 * %d - %d as X%d", 
                    seq_len(p),
                    seq_len(p),
                    seq_len(p)), 
            collapse=",\n ")
Ys <- "rand() < 1 / (1 + EXP(- (X1 * X2 + X3 + SIN(X4)))) AS Y"
sql <- sprintf("
SELECT %s, *
FROM (SELECT %s
      FROM id)", Ys, Xs)
cat(sql)
dat <- sdf_sql(sc, sql) %>%
  compute(name="dat")

dat

# Set up a function that does transformation, 
# instead of actually transforming data
ft <- ft_r_formula(sc, Y ~ X1:X2 + ., features_col = "features")

# ft1 <- ft_r_formula(dat, Y ~ X1:X2 + ., features_col = "features")
# ft1 %>% glimpse()
# 
# a <- ft1 %>% collect()

# Normalizer
scaler <- ft_standard_scaler(sc, # A Spark connection here
                             input_col = "features",
                             output_col = "features_scaled",
                             with_mean = TRUE)


# Logistic regression
lr <- ml_logistic_regression(sc, features_col="features_scaled", label_col="label")

pipe <- ml_pipeline(ft, 
                    scaler, 
                    lr)
pipe

# b <- ml_fit(pipe, dat)
# b


ev <- ml_binary_classification_evaluator(sc)

grid <- list(
  logistic_regression = list(elastic_net_param = c(0, 1), # 0 for L2, 1 for L1
                             reg_param = 10^c(-4, -2))
)

cv <- ml_cross_validator(
  sc,
  estimator=pipe,
  estimator_param_maps = grid,
  evaluator = ev,
  num_folds = 2)

mod <- ml_fit(cv, dat)
mod
mod$best_model$stages[[3]] %>% coefficients

ml_validation_metrics(mod)



config <- spark_config()
config["sparklyr.shell.driver-memory"] <- "370g"
config["spark.executor.memory"] <- "370g"
# Fraction of memory for execution and storage
config["spark.memory.fraction"] <- 0.6
sc <- spark_connect(master = Sys.getenv("SPARK_URL"), 
                    config=config)

localhost:4040