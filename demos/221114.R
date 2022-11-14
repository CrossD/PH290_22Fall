library(RSQLite)
db <- dbConnect(RSQLite::SQLite(), "mimicDemo.sqlite")
dbListTables(db)

dbGetQuery(db,
           "SELECT * FROM admissionsMini
            WHERE HADM_ID IN (SELECT HADM_ID FROM diagnosisMini 
                  GROUP BY HADM_ID
                  HAVING count(*) > 1);")

dbGetQuery(db,
           "SELECT * FROM admissionsMini as A
            WHERE EXISTS (SELECT DIAGNOSIS FROM admissionsMini 
              WHERE SUBJECT_ID != A.SUBJECT_ID AND 
                    DIAGNOSIS = A.DIAGNOSIS)")

q <- "WITH tab1 AS (SELECT * 
  FROM ad AS A INNER JOIN diagnosisMini AS B 
  ON A.HADM_ID = B.HADM_ID AND A.SUBJECT_ID = B.SUBJECT_ID), 
  tab2 AS (SELECT * FROM diagnosisMini LIMIT 1)
SELECT * 
FROM tab1 JOIN tab2
USING (HADM_ID, SUBJECT_ID);"
dbGetQuery(db, q)

dbGetQuery(db, 
           "SELECT * 
  FROM (SELECT ROW_NUMBER() 
        OVER (PARTITION BY ETHNICITY) as rn, *
        FROM admTmp)
  where rn <= 2;")

dbGetQuery(db, 
           "SELECT * 
  FROM (SELECT RANK() 
        OVER (PARTITION BY ETHNICITY ORDER BY HADM_ID) as rk, *
        FROM admTmp)
  where rk <= 2;")


a <- dbGetQuery(db, 
"SELECT SUM(X) OVER (
    ORDER BY HADM_ID
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) as CUMSUM, *
FROM admTmp;")

a <- dbGetQuery(db, 
"SELECT SUM(X) OVER (
  PARTITION BY ETHNICITY
  ORDER BY HADM_ID
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS CUMSUM, *
FROM admTmp;")


library(bigrquery)
library(DBI)
db <- dbConnect(
  bigrquery::bigquery(),
  project = "mimic-3-ph-290",
  dataset = "mimic3_mod",
  billing = "mimic-3-ph-290"
)
db
dbListTables(db)

topItems <- dbGetQuery(db, 
                       "SELECT DISTINCT ITEMID, COUNT(*) as COUNT 
  FROM chartevents JOIN d_items
  USING (ITEMID)
  GROUP BY ITEMID
  ORDER BY COUNT DESC
  LIMIT 50;")

tmp <- dbSendQuery(db, 
                       "SELECT DISTINCT ITEMID, COUNT(*) as COUNT 
  FROM chartevents JOIN d_items
  USING (ITEMID)
  GROUP BY ITEMID
  ORDER BY COUNT DESC
  LIMIT 50;")
tmp
dbFetch(tmp, n=2)
