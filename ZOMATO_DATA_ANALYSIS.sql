-- 01_country_percentage.sql
WITH total_count AS (
  SELECT COUNT(*) AS total_rest FROM ZomatoData1
),
country_counts AS (
  SELECT COUNTRY_NAME, COUNT(RestaurantID) AS rest_count
  FROM ZomatoData1
  GROUP BY COUNTRY_NAME
)
SELECT c.COUNTRY_NAME,
       c.rest_count,
       ROUND(100.0 * c.rest_count / t.total_rest, 2) AS pct_of_restaurants
FROM country_counts c
CROSS JOIN total_count t
ORDER BY pct_of_restaurants DESC, c.COUNTRY_NAME;

-- 02_online_delivery_by_country.sql
WITH country_rest AS (
  SELECT COUNTRY_NAME, COUNT(*) AS rest_count
  FROM ZomatoData1
  GROUP BY COUNTRY_NAME
)
SELECT z.COUNTRY_NAME,
       COUNT(*) AS online_delivery_restaurants,
       ROUND(100.0 * COUNT(*) / c.rest_count, 2) AS pct_with_online_delivery
FROM ZomatoData1 z
JOIN country_rest c
  ON z.COUNTRY_NAME = c.COUNTRY_NAME
WHERE UPPER(z.Has_Online_delivery) = 'YES'
GROUP BY z.COUNTRY_NAME, c.rest_count
ORDER BY online_delivery_restaurants DESC, z.COUNTRY_NAME;

-- 03_top_indian_localities.sql
SELECT City, Locality, COUNT(RestaurantID) AS rest_count
FROM ZomatoData1
WHERE COUNTRY_NAME = 'India'
GROUP BY City, Locality
ORDER BY rest_count DESC, City, Locality
LIMIT 10;

-- 04_popular_cuisines_connaught_place.sql
WITH top_locality AS (
  SELECT Locality
  FROM ZomatoData1
  WHERE COUNTRY_NAME = 'India'
  GROUP BY Locality
  ORDER BY COUNT(*) DESC
  LIMIT 1
),
split_cuisines AS (
  SELECT TRIM(SUBSTR(Cuisines, 1, INSTR(Cuisines || ',', ',') - 1)) AS cuisine,
         SUBSTR(Cuisines || ',', INSTR(Cuisines || ',', ',') + 1) AS rest,
         Locality
  FROM ZomatoData1
  WHERE Locality = (SELECT Locality FROM top_locality)

  UNION ALL

  SELECT TRIM(SUBSTR(rest, 1, INSTR(rest, ',') - 1)) AS cuisine,
         SUBSTR(rest, INSTR(rest, ',') + 1) AS rest,
         Locality
  FROM split_cuisines
  WHERE rest <> ''
)
SELECT cuisine, COUNT(*) AS cuisine_count
FROM split_cuisines
WHERE cuisine <> ''
GROUP BY cuisine
ORDER BY cuisine_count DESC, cuisine
LIMIT 10;

-- 05_table_booking_top_locality.sql
WITH top_locality AS (
  SELECT Locality
  FROM ZomatoData1
  WHERE COUNTRY_NAME = 'India'
  GROUP BY Locality
  ORDER BY COUNT(*) DESC
  LIMIT 1
)
SELECT Locality,
       COUNT(*) AS table_booking_option
FROM ZomatoData1
WHERE Locality = (SELECT Locality FROM top_locality)
  AND UPPER(Has_Table_booking) = 'YES'
GROUP BY Locality;

-- 06_connaught_place_rating_table_vs_no.sql
SELECT 'WITH_TABLE' AS table_booking_opt,
       COUNT(*) AS total_rest,
       ROUND(AVG(CAST(Rating AS REAL)), 2) AS avg_rating
FROM ZomatoData1
WHERE UPPER(Has_Table_booking) = 'YES'
  AND Locality = 'Connaught Place'
UNION ALL
SELECT 'WITHOUT_TABLE' AS table_booking_opt,
       COUNT(*) AS total_rest,
       ROUND(AVG(CAST(Rating AS REAL)), 2) AS avg_rating
FROM ZomatoData1
WHERE UPPER(Has_Table_booking) = 'NO'
  AND Locality = 'Connaught Place';

-- 07_best_moderately_priced_indian_restaurants.sql
SELECT RestaurantID, RestaurantName, City, Locality, Cuisines, Votes,
       Average_Cost_for_two, Rating
FROM ZomatoData1
WHERE COUNTRY_NAME = 'India'
  AND UPPER(Has_Table_booking) = 'YES'
  AND UPPER(Has_Online_delivery) = 'YES'
  AND Price_range <= 3
  AND Votes > 1000
  AND Average_Cost_for_two < 1000
  AND Rating > 4
  AND UPPER(Cuisines) LIKE '%INDIAN%'
ORDER BY Rating DESC, Votes DESC, Average_Cost_for_two ASC
LIMIT 10;

