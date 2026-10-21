-- Tables: public.company_dim, public.skills_dim, public.job_postings_fact, and public.skills_job_dim

COPY public.company_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.skills_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.job_postings_fact
FROM 'D:\Co\SQL\bootscamp\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.skills_job_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT company_id, COUNT(*)
FROM public.company_dim
GROUP BY company_id
HAVING COUNT(*) > 1;

select * FROM company_dim
limit 100;

select 
Job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IOT'
from job_postings_fact;

select 
extract(month from job_posted_date)
from
    job_postings_fact;

DROP TABLE IF EXISTS jan_job_posting;
CREATE TABLE jan_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

select * from jan_job_posting;

DROP TABLE IF EXISTS feb_job_posting;
CREATE TABLE feb_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

select * from feb_job_posting;

DROP TABLE IF EXISTS mar_job_posting;
CREATE TABLE mar_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

select * from mar_job_posting;

DROP TABLE IF EXISTS apr_job_posting;
CREATE TABLE apr_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

select * from apr_job_posting;

DROP TABLE IF EXISTS may_job_posting;  
CREATE TABLE may_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

select * from may_job_posting;

DROP TABLE IF EXISTS jun_job_posting;
CREATE TABLE jun_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

select * from jun_job_posting;

DROP TABLE IF EXISTS jul_job_posting;
CREATE TABLE jul_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

select * from jul_job_posting;

DROP TABLE IF EXISTS aug_job_posting;
CREATE TABLE aug_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

select * from aug_job_posting;

DROP TABLE IF EXISTS sep_job_posting;
CREATE TABLE sep_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

select * from sep_job_posting;

DROP TABLE IF EXISTS oct_job_posting;
CREATE TABLE oct_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

select * from oct_job_posting;

DROP TABLE IF EXISTS nov_job_posting;
CREATE TABLE nov_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

select * from nov_job_posting;

DROP TABLE IF EXISTS dec_job_posting;
CREATE TABLE dec_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 12;

select * from dec_job_posting;

SELECT 
    job_title,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact;

SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title = 'Data Analyst'
GROUP BY
    location_category;
   
SELECT 
    salary_year_avg,
    CASE 
        WHEN salary_year_avg > 100000 THEN 'high'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'standard'
        WHEN salary_year_avg < 60000 THEN 'low'
        ELSE 'unspecified'
    END AS salary_category
FROM job_postings_fact;


select * 
   from (
    select * from job_postings_fact
    where extract(month from job_posted_date) = 1
   ) AS january_job_postings;







    
