library(RSQLite)
db <- dbConnect(RSQLite::SQLite(), "mimicDemo.sqlite")
q <- "
CREATE TABLE admissionsMini
(
  SUBJECT_ID INT,
  HADM_ID INT,
  ETHNICITY VARCHAR(200),
  INSURANCE VARCHAR(255),
  DIAGNOSIS VARCHAR(255),
  PRIMARY KEY (HADM_ID)
);
"
dbExecute(db, q)
dat <- readr::read_csv('demoData/ADMISSIONSmini.csv')
dbWriteTable(db, "admissionsMini", dat, append=TRUE)
a <- dbGetQuery(db, "SELECT * FROM admissionsMini")
dbListTables(db)

q <- "select DIAGNOSIS
FROM admissionsMini
WHERE ETHNICITY = 'WHITE';"
q <- "select DISTINCT DIAGNOSIS
FROM admissionsMini
WHERE ETHNICITY = 'WHITE';"
q <- "select DISTINCT DIAGNOSIS AS INITDIAG
FROM admissionsMini
WHERE ETHNICITY = 'WHITE';"
a <- dbGetQuery(db, q)

dbGetQuery(db, "SELECT 'abc' LIKE 'a%b'") # % matches any substring of length 0+
dbGetQuery(db, "SELECT 'abc' LIKE 'a_c'") # _ matches any single character when used with LIKE

q <- "SELECT * FROM admissionsMini
WHERE ETHNICITY LIKE '%HISPANIC%';"
dbGetQuery(db, q)

# Create a table from a query
q <- "CREATE TABLE whiteTmp AS
SELECT * 
FROM admissionsMini
WHERE ETHNICITY = 'WHITE';"
dbExecute(db, q)
dbListTables(db)

q <- "SELECT DISTINCT DIAGNOSIS
FROM whiteTmp
ORDER BY DIAGNOSIS
LIMIT 5
OFFSET 20;"
dbGetQuery(db, q)

q <- "SELECT DIAGNOSIS
FROM admissionsMini
WHERE ETHNICITY LIKE '%HISPANIC%'
ORDER BY HADM_ID
LIMIT 5
OFFSET 5;"
dbGetQuery(db, q)

# Aggregators
dbExecute(db, "
CREATE TABLE admTmp AS
SELECT ABS(RANDOM() % 10) AS X, *
FROM admissionsMini;")

dbGetQuery(db, "SELECT COUNT(*) AS TOTAL, AVG(X)
FROM admTmp;")

q <- "SELECT ETHNICITY, AVG(X) AS avgX
FROM admTmp
GROUP BY ETHNICITY
HAVING avgX > 5"
dbGetQuery(db, q)

# Combining tables
q <- "CREATE TABLE pneuTmp AS
SELECT *
FROM admissionsMini
WHERE DIAGNOSIS LIKE '%PNEUMONIA%';"
dbExecute(db, q)

q <- "SELECT HADM_ID, 'WHITE' AS REASON
FROM whiteTmp
UNION
SELECT HADM_ID, 'PNEU' AS REASON
FROM pneuTmp;"
a <- dbGetQuery(db, q)
dbGetQuery(db, "SELECT COUNT(*) FROM whiteTmp")

q <- "SELECT HADM_ID
FROM whiteTmp
INTERSECT
SELECT HADM_ID
FROM pneuTmp;"
dbGetQuery(db, q)

qs <- c(
  "DROP TABLE IF EXISTS diagnosisMini;",
  " CREATE TABLE diagnosisMini 
(
  SUBJECT_ID INT,
  HADM_ID INT,
  SEQ_NUM INT,
  ICD9_CODE VARCHAR(10)
 );", 
  "INSERT INTO diagnosisMini
VALUES
(10006, 142345, 1, '99591'),
(10006, 142345, 2, '99662'),
(10007, 195315, 1, '99591'),
(10007, 195315, 2, '40391'),
(10042, 148562, 1, '99591')
;")
cat(qs)
lapply(qs, dbExecute, conn=db)

dbExecute(db, "CREATE TABLE IF NOT EXISTS ad AS
SELECT * FROM admissionsMini 
WHERE HADM_ID LIKE '14%';")
dbGetQuery(db, "SELECT * FROM ad;")

a <- dbGetQuery(db, "SELECT * FROM ad JOIN diagnosisMini")

# Inner join
a <- dbGetQuery(db, "SELECT * 
FROM ad JOIN diagnosisMini
ON ad.HADM_ID = diagnosisMini.HADM_ID")

a <- dbGetQuery(db, "SELECT * 
FROM ad NATRUAL JOIN diagnosisMini
USING (SUBJECT_ID, HADM_ID);")

# Outer joins
a <- dbGetQuery(db, "SELECT *
FROM ad AS A LEFT JOIN diagnosisMini AS B
ON A.HADM_ID = B.HADM_ID;")

a <- dbGetQuery(db, "SELECT *
FROM ad AS A FULL JOIN diagnosisMini AS B
ON A.HADM_ID = B.HADM_ID;")


a <- dbGetQuery(db, "SELECT A.*
FROM ad AS A LEFT JOIN diagnosisMini AS B
ON A.HADM_ID = B.HADM_ID
WHERE B.HADM_ID IS NULL;")
a

dbGetQuery(db, "SELECT NULL AND false")

# YOUR TURN
q <- "SELECT SUBJECT_ID
FROM admissionsMini
WHERE DIAGNOSIS LIKE '%SEPSIS'
EXCEPT
SELECT SUBJECT_ID
FROM admissionsMini
WHERE ETHNICITY = 'WHITE';"
dbGetQuery(db, q)

q <- "SELECT *
FROM admissionsMini AS A LEFT JOIN diagnosisMini AS B
ON A.HADM_ID = B.HADM_ID
WHERE A.DIAGNOSIS LIKE '%SEPSIS%';"
a <- dbGetQuery(db, q)

q <- "SELECT *
FROM (SELECT SUBJECT_ID
  FROM admissionsMini
  WHERE DIAGNOSIS LIKE '%SEPSIS'
  EXCEPT
  SELECT SUBJECT_ID
  FROM admissionsMini
  WHERE ETHNICITY = 'WHITE') AS A 
  JOIN admissionsMini as B
ON A.SUBJECT_ID = B.SUBJECT_ID;"
dbGetQuery(db, q)


