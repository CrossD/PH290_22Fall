library(RSQLite)
db <- dbConnect(RSQLite::SQLite(), "mimicDemo.sqlite")
db
dbDisconnect(db)
db

q <- "CREATE TABLE admissionsMini
(
  SUBJECT_ID INT,
  HADM_ID INT,
  ETHNICITY VARCHAR(200),
  INSURANCE VARCHAR(200),
  DIAGNOSIS VARCHAR(200)
);"
cat(q)
  
dbExecute(db, q)
dbListTables(db)
dbGetQuery(db, "SELECT * FROM admissionsMini;")

dbExecute(db, "DROP TABLE admissionsMini;")
dbListTables(db)

dbExecute(db, "DROP TABLE IF EXISTS admissionsMini;")
q <- "CREATE TABLE admissionsMini
(
  SUBJECT_ID INT,
  HADM_ID INT,
  ETHNICITY VARCHAR(200),
  INSURANCE VARCHAR(200),
  DIAGNOSIS VARCHAR(200),
  PRIMARY KEY (HADM_ID)
);"
dbExecute(db, q)

q <- "INSERT INTO admissionsMini 
  VALUES (9999, 11111, 'WHITE', 'MEDICARE', 'SEPSIS'),
         (9998, 22222, 'HISPANIC', 'PRIVATE', 'SEPSIS');"
dbExecute(db, q)

dbGetQuery(db, "SELECT * FROM admissionsMini;")

dat <- readr::read_csv('database/demoData/ADMISSIONSmini.csv')
dbWriteTable(db, "admissionsMini", dat, append=TRUE)
dbGetQuery(db, "SELECT * FROM admissionsMini;")
