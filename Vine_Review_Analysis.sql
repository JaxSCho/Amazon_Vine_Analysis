-- Vine table schema
CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);

-- Check vine table after csv import
select * from vine_table limit 20;
select count(*) from vine_table; -- 2,642,434 records

-- 1. Filter the data and create a table to retrieve all the rows where 
-- the total_votes count is equal to or greater than 20 to pick reviews that are more likely 
-- to be helpful and to avoid having division by zero errors later on.
SELECT * 
  INTO vine_table_20plus_totvotes
  FROM vine_table
  WHERE total_votes >= 20; -- 48,163 records

-- 2. Filter the new table created in Step 1 and create a new table to retrieve all the rows 
-- where the number of helpful_votes divided by total_votes is equal to or greater than 50%.
-- Hint: cast your columns as floats using WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5.
SELECT *
   INTO vine_table_helpful
   FROM vine_table_20plus_totvotes
   WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5; -- 44,714 records

-- 3. Filter the DataFrame or table created in Step 2, and create a new DataFrame or table that retrieves 
-- all the rows where a review was written as part of the Vine program (paid), vine == 'Y'.
SELECT *
   INTO vine_table_helpful_paid
   FROM vine_table_helpful
   WHERE vine = 'Y'; -- 969 records

-- 4. Repeat Step 3, but this time retrieve all the rows where the review 
-- was not part of the Vine program (unpaid), vine == 'N'.
SELECT *
   INTO vine_table_helpful_unpaid
   FROM vine_table_helpful
   WHERE vine = 'N'; -- 43,745 records

-- 5. Determine the total number of reviews, the number of 5-star reviews, 
-- and the percentage of 5-star reviews for the two types of review (paid vs unpaid).
;WITH vine AS
(
  SELECT CASE WHEN vine = 'Y' THEN 'Paid' ELSE 'Unpaid' END AS review_type,
	   COUNT(*) AS total_reviews,
	   SUM(CASE WHEN star_rating = 5 THEN 1 ELSE 0 END) AS five_star_review_cnt
  FROM vine_table_helpful 
  GROUP BY vine
)
SELECT review_type, total_reviews, five_star_review_cnt,
	   CAST(five_star_review_cnt AS FLOAT)/CAST(total_reviews AS FLOAT) * 100 AS five_star_perc
   FROM vine;
  















