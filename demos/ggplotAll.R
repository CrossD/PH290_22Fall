library(tidyverse)
library(rlang)

dat <- read_csv("../dataset_diabetes/diabetic_data.csv")

# I want to visualize every single variable vs A1Cresult.
# For numeric columns, use a side-by-side histogram; 
# for categorical columns, use a side-by-side barchart. 
plotDat <- dat %>%
  filter(A1Cresult != "None") %>% 
  select(-encounter_id, -patient_nbr)


groupCol <- "A1Cresult"
col <- "time_in_hospital"

# SE 2nd and 3rd arguments, which should be character scalars
plotCol <- function(data, col, groupCol) {
  if (col == groupCol) return()

  type <- class(data[[col]])

  if (type == "numeric") {
    geom <- function(...) geom_histogram(position="dodge", ...)
  } else if (type == "character") {
    geom <- function(...) geom_bar(position="fill", ...)
  }

  p <- ggplot(data, aes(x = !!as.symbol(col), 
                       fill=!!as.symbol(groupCol))) + 
    geom()
  p
}

plotCol(plotDat, col, groupCol)
pList <- map(names(plotDat), plotCol, 
             data=plotDat, groupCol="A1Cresult")
cowplot::plot_grid(plotlist=pList[1:20])

## Within each group defined varA, are varB and varC associated?

res <- dat %>%
  select(c(gender, A1Cresult, race)) %>%
  group_by(gender) %>%
  nest() %>%
  ungroup() %>% 
  mutate(chisq = map(data, function(dd) try(chisq.test(dd[[1]], dd[[2]])))) %>%
  filter(map(chisq, class) == "htest") %>%
  mutate(pv = map_dbl(chisq, `[[`, "p.value"),
         varA = "gender", varB="A1Cresult", varC = "race")

# NSE for varA, varB, and varC
BC_by_A <- function(data, varA, varB, varC) {
  res <- data %>%
    select(c({{varA}}, {{varB}}, {{varC}})) %>%
    group_by({{varA}}) %>%
    nest() %>%
    ungroup() %>% 
    mutate(chisq = map(.data$data,  # data column, not the entire dataset
                       function(dd) try(chisq.test(dd[[1]], dd[[2]])))) %>%
    filter(map(chisq, class) == "htest") %>%
    mutate(pv = map_dbl(chisq, `[[`, "p.value"),
           varA=deparse1(enquo(varA)), 
           varB=deparse1(enquo(varB)),
           varC=deparse1(enquo(varC))
    )
  res
}
BC_by_A(dat, gender, A1Cresult, race)
BC_by_A(dat, race, A1Cresult, gender)
