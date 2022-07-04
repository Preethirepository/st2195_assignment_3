library(DBI)
conn <- dbConnect(RSQLite::SQLite(), "airline2.db")
dbListTables(conn)
q1 <- dbGetQuery(conn,
 "SELECT model AS model, AVG(ontime.DepDelay) AS avg_delay

FROM planes JOIN ontime USING(tailnum)

WHERE ontime.Cancelled = 0 AND ontime.Diverted = 0 AND ontime.DepDelay > 0

GROUP BY model

ORDER BY avg_delay")
q1

q1 <- dbSendQuery(conn,
                  "SELECT

    q1.carrier AS carrier, (CAST(q1.numerator AS FLOAT)/ CAST(q2.denominator AS FLOAT)) AS ratio

FROM

(

    SELECT carriers.Description AS carrier, COUNT(*) AS numerator

    FROM carriers JOIN ontime ON ontime.UniqueCarrier = carriers.Code

    WHERE ontime.Cancelled = 1 AND carriers.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')

    GROUP BY carriers.Description

) AS q1 JOIN

(

    SELECT carriers.Description AS carrier, COUNT(*) AS denominator

    FROM carriers JOIN ontime ON ontime.UniqueCarrier = carriers.Code

    WHERE carriers.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')

    GROUP BY carriers.Description

) AS q2 USING(carrier)
    ORDER BY ratio DESC")
q1

q1<- dbSendQuery(conn,
      "SELECT carriers.Description AS carrier, COUNT(*) AS total

FROM carriers JOIN ontime ON ontime.UniqueCarrier = carriers.Code

WHERE ontime.Cancelled = 1

    AND carriers.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')

GROUP BY carriers.Description

ORDER BY total DESC")
q1
  
q4 <- dbSendQuery(conn,
                  "SELECT airports.city AS city, COUNT(*) AS total

FROM airports JOIN ontime ON ontime.dest = airports.iata

WHERE ontime.Cancelled = 0

GROUP BY airports.city

ORDER BY total DESC")
q4

library(DBI)
conn <- dbConnect(RSQLite::SQLite(), "flight.db")
dbListTables(conn)


library(dplyr)
airports_db <- tbl(conn, "Airports")
carriers_db <- tbl(conn, "Carriers")
ontime_db <- tbl(conn, "Ontime")
plane_db <- tbl(conn, "Plane")
q1 <- airports_db %>% filter(state == "GA")
q1

show_query(q1)

q2 <- inner_join(plane_db, ontime_db) %>%
  select(model, AVG(ontime.DepDelay), avg_delay) %>%
  inner_join(planes.ontime (tailnum)) %>%
  filter(ontime.Cancelled = 0, ontime.Diverted = 0, ontime.DepDelay > 0) %>%
  group_by(model) %>%
  arrange(avg_delay)
q2
 
show_query(q2)
  



















