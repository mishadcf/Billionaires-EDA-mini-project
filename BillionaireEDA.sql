-- Top 10 Countries with the Highest Number of Billionaires: Retrieve the top 10 countries with the highest number of billionaires.
with ranked as (SELECT country, count(*), RANK() OVER (ORDER BY count(*) desc) as rnk
FROM Billionaires
GROUP BY country)

SELECT * from ranked
WHERE rnk<=10



-- Average Age of Billionaires by Industry: Calculate the average age of billionaires for each industry, starting from oldest av. age

SELECT AVG(age::NUMERIC), industry from Billionaires
WHERE age <> 'N/A'
GROUP BY industry
ORDER by 1 DESC

-- Wealth Distribution by Country: Determine the distribution of billionaires' net worth across different countries.
ALTER TABLE BIllionaires 
ALTER COLUMN net_worth TYPE NUMERIC using net_worth::NUMERIC

SELECT country, SUM(net_worth) as aggregate_billionaire_wealth
FROM Billionaires
GROUP BY 1 
ORDER by 2 DESC

-- Source of Wealth Distribution: Analyze the distribution of billionaires based on their source of wealth (e.g., technology, real estate, finance).

SELECT sources, SUM(net_worth) as total_net_worth
FROM Billionaires
GROUP BY 1
ORDER by total_net_worth desc



ALTER TABLE Billionaires
ALTER COLUMN age TYPE NUMERIC USING (CASE WHEN age <> 'N/A' THEN age::NUMERIC END);



-- Youngest and Oldest Billionaires: Identify the youngest and oldest billionaires in the dataset.
SELECT
  youngest.naming AS youngest_name,
  youngest.age AS youngest_age,
  oldest.naming AS oldest_name,
  oldest.age AS oldest_age
FROM
  billionaires youngest
  CROSS JOIN billionaires oldest
WHERE
  youngest.age = (SELECT MIN(age) FROM billionaires)
  AND oldest.age = (SELECT MAX(age) FROM billionaires);

-- Richest Billionaires: Find the top 10 billionaires with the highest net worth.

with ranked as 

(SELECT naming, net_worth, RANK () OVER (ORDER BY net_worth desc) rnk
FROM Billionaires)

SELECT * from ranked
WHERE rnk<11;


-- Number of billionaires by Industry: Count the number of billionaires in each industry.
SELECT industry, COUNT(distinct naming) as n_billionaires
FROM Billionaires
GROUP BY industry
ORDER by 2;

-- Wealthiest Industries: Determine the industries with the highest total net worth of billionaires.
SELECT industry, SUM (net_worth) as total_net_worth
FROM Billionaires
GROUP BY 1
ORDER by 2 desc;

-- Top Billionaires in Each Country: Retrieve the wealthiest billionaire from each country.

with country_ranks as (SELECT 
 country, 
 naming, 
 RANK() OVER (partition by country ORDER by net_worth DESC) as country_rank
FROM Billionaires)

SELECT * from country_ranks
WHERE country_rank=1
 
-- Billionaires by Birth Year: Group billionaires by birth year and determine which years have the highest number of billionaires.
SELECT age, COUNT(*) as n_by_age
FROM Billionaires
GROUP BY age
ORDER by 2 desc;

--**INCONCLUSIVE given [null] values

--Histogram of billionaire numbers by age buckets

SELECT 
  CONCAT(FLOOR(age / 10) * 10, ' - ', FLOOR(age / 10) * 10 + 9) AS age_range_label,
  COUNT(*) AS count_of_billionaires
FROM Billionaires
WHERE age IS NOT NULL
GROUP BY FLOOR(age / 10)
ORDER BY MIN(age);








