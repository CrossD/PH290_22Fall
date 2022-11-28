library(sparklyr)
library(dplyr)
library(dbplot)
library(ggplot2)
sc <- spark_connect(master = "local", version = "3.3.1")
sc

cars <- copy_to(sc, mtcars)
cars
str(cars)

cars %>%
  group_by(cyl) %>% 
  summarize(mean(mpg)) %>%
  show_query()

sdf_sql(sc, "SELECT cyl, AVG(mpg) 
             FROM mtcars 
             GROUP BY cyl")

cars %>%
  group_by(cyl) %>% 
  summarize(percentile(mpg, 0.9))

x <- cars %>%
  group_by(cyl) %>% 
  summarize(percentile(mpg, 0.9)) %>%
  compute()
x

class(x)

y <- cars %>%
  group_by(cyl) %>% 
  summarize(percentile(mpg, 0.9)) %>%
  collect()

str(y)

cars %>%
  group_by(cyl) %>% 
  summarize(percentile(mpg, 0.9)) %>%
  spark_dataframe() %>%
  invoke("queryExecution")


p <- cars %>%
  dbplot_histogram(mpg, binwidth = 3) +
  ggtitle("mpg")
p

sdf_describe(cars)

sdf_crosstab(cars, "cyl", "mpg")

n <- cars %>%
  tally() %>% 
  collect() %>%
  .$n

rd <- sdf_rt(sc, n, 2)
cars1 <- sdf_bind_cols(rd, cars)

cars1

split <- sdf_random_split(cars, train=0.5, test=0.5)
split

m <- split$train %>%
  ml_linear_regression(mpg ~ ., 
                       elastic_net_param = 1, # lasso
                       reg_param = 0.5)

ev <- ml_evaluate(m, split$test)

names(ev)

ev$predictions %>%
  print(width=Inf)

spark_web(sc)

spark_log(sc)
spark_disconnect(sc)
