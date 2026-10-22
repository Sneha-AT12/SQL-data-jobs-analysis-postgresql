SELECT 
 skills_dim.skills AS UNIQUE_skills,
 count(skills_job_dim.skill_id) as number_of_job_posting,
 avg(job_postings_fact.salary_year_avg) AS avg_sal_skills
FROM 
	skills_dim 
left join 
	skills_job_dim 
	on skills_job_dim.skill_id = skills_dim.skill_id
  left join 
	job_postings_fact
	on job_postings_fact.job_id = skills_job_dim.job_id
group by 
	skills_dim.skills
order by 
	avg_sal_skills DESC;



-- public.company_dim, 
-- public.skills_dim, 
-- public.job_postings_fact, and public.skills_job_dim


COPY company_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'D:\Co\SQL\bootscamp\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT company_id, COUNT(*)
FROM public.company_dim
GROUP BY company_id
HAVING COUNT(*) > 1;

TRUNCATE TABLE
    public.skills_job_dim,
    public.job_postings_fact,
    public.skills_dim,
    public.company_dim
RESTART IDENTITY CASCADE;

select * FROM company_dim
limit 100;

select 
Job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IOT'
from job_postings_fact;

select 
extract(month from job_posted_date)
from
    job_postings_fact;

DROP TABLE IF EXISTS jan_job_postings;
CREATE TABLE jan_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

select * from jan_job_posting;

DROP TABLE IF EXISTS feb_job_postings;
CREATE TABLE feb_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

select * from feb_job_posting;

DROP TABLE IF EXISTS mar_job_postings;
CREATE TABLE mar_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

select * from mar_job_posting;

DROP TABLE IF EXISTS apr_job_postings;
CREATE TABLE apr_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

select * from apr_job_posting;

DROP TABLE IF EXISTS may_job_postings;  
CREATE TABLE may_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

select * from may_job_posting;

DROP TABLE IF EXISTS jun_job_postings;
CREATE TABLE jun_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

select * from jun_job_posting;

DROP TABLE IF EXISTS jul_job_postings;
CREATE TABLE jul_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

select * from jul_job_posting;

DROP TABLE IF EXISTS aug_job_postings;
CREATE TABLE aug_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

select * from aug_job_posting;

DROP TABLE IF EXISTS sep_job_postings;
CREATE TABLE sep_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

select * from sep_job_posting;

DROP TABLE IF EXISTS oct_job_postings;
CREATE TABLE oct_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

select * from oct_job_posting;

DROP TABLE IF EXISTS nov_job_postings;
CREATE TABLE nov_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

select * from nov_job_posting;

DROP TABLE IF EXISTS dec_job_postings;
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
whe

select * 
   from (
    select * from job_postings_fact
    where extract(month from job_posted_date) = 1
   )

-- COPY public.company_dim FROM 'D:\Co\SQL\bootscamp\csv_files\company_dim.csv' WITH (FORMAT csv, HEADER true);

-- 1. Check your current database and schema
SELECT current_database(), current_schema(), current_user;

-- 2. Check whether the tables exist
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name IN (
    'company_dim',
    'skills_dim',
    'job_postings_fact',
    'skills_job_dim'
);

-- 3. Check specifically for company_dim
SELECT to_regclass('public.company_dim');

-- 4. Check all schemas for company_dim
SELECT schemaname, tablename
FROM pg_catalog.pg_tables
WHERE tablename = 'company_dim';

-- 5. Check the table structure
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'company_dim'
ORDER BY ordinal_position;

-- 6. Load company_dim
COPY public.company_dim
FROM 'D:/Co/SQL/bootscamp/csv_files/company_dim.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

-- 10. Test the tables

SELECT 
 skills_dim.skills AS UNIQUE_skills,
 count(skills_job_dim.skill_id) as number_of_job_posting,
 avg(job_postings_fact.salary_year_avg) AS avg_sal_skills
FROM 
	skills_dim 
left join 
	skills_job_dim 
	on skills_job_dim.skill_id = skills_dim.skill_id
  left join 
	job_postings_fact
	on job_postings_fact.job_id = skills_job_dim.job_id
group by 
	skills_dim.skills
order by 
	avg_sal_skills DESC;



public.company_dim, 
public.skills_dim, 
public.job_postings_fact, and public.skills_job_dim

COPY company_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'D:\Co\SQL\bootscamp\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'D:\Co\SQL\bootscamp\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT company_id, COUNT(*)
FROM public.company_dim
GROUP BY company_id
HAVING COUNT(*) > 1;

TRUNCATE TABLE
    public.skills_job_dim,
    public.job_postings_fact,
    public.skills_dim,
    public.company_dim
RESTART IDENTITY CASCADE;

select * FROM company_dim
limit 100;

select 
Job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IOT'
from job_postings_fact;

select 
extract(month from job_posted_date)
from
    job_postings_fact;

DROP TABLE IF EXISTS jan_job_postings;
CREATE TABLE jan_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

select * from jan_job_posting;

DROP TABLE IF EXISTS feb_job_postings;
CREATE TABLE feb_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

select * from feb_job_posting;

DROP TABLE IF EXISTS mar_job_postings;
CREATE TABLE mar_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

select * from mar_job_posting;

DROP TABLE IF EXISTS apr_job_postings;
CREATE TABLE apr_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

select * from apr_job_posting;

DROP TABLE IF EXISTS may_job_postings;  
CREATE TABLE may_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

select * from may_job_posting;

DROP TABLE IF EXISTS jun_job_postings;
CREATE TABLE jun_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

select * from jun_job_posting;

DROP TABLE IF EXISTS jul_job_postings;
CREATE TABLE jul_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

select * from jul_job_posting;

DROP TABLE IF EXISTS aug_job_postings;
CREATE TABLE aug_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

select * from aug_job_posting;

DROP TABLE IF EXISTS sep_job_postings;
CREATE TABLE sep_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

select * from sep_job_posting;

DROP TABLE IF EXISTS oct_job_postings;
CREATE TABLE oct_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

select * from oct_job_posting;

DROP TABLE IF EXISTS nov_job_postings;
CREATE TABLE nov_job_posting AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

select * from nov_job_posting;

DROP TABLE IF EXISTS dec_job_postings;
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
   ) AS jan_posted

--cte
WITH jan_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT *
FROM jan_jobs;

select 
   company_id,
from 
	job_postings_fact
where
	job_no_degree_mention = true;

select 
	company_id, 
	name
from 
	company_dim
where company_id IN (
select 
	company_id
from
	job_postings_fact
where 	
	job_no_degree_mention = true
)

with company_job_count as (
select 
	 company_id,
	 count(*) as total_jobs
from 
	job_postings_fact
group by 
	company_id
)
select *
from 
	company_job_count;

	

	

with company_job_count as (
select 
	 company_id,
	 count(*) as total_jobs
from 
	job_postings_fact
group by 
	company_id
)
select 
	company_dim.name,
	company_job_count.total_jobs
from 
	company_dim
left join
	company_job_count ON company_job_count.company_id = company_dim.company_id
order by
	total_jobs desc;


	
select 
	job_postings_fact.job_id,
	skill_id
from
	skills_job_dim
inner join job_postings_fact on skills_job_dim.job_id = job_postings_fact.job_id
where 	
	job_postings_fact.job_work_from_home = true ; 

with remote_job_skills as (
SELECT
    job_postings_fact.job_id,
    skills_dim.skills AS skill
FROM skills_job_dim
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE job_postings_fact.job_work_from_home = TRUE
)
select *
from
	remote_job_skills;




SELECT
    skills_job_dim.skill_id,
    skills_dim.skills AS skill,
    COUNT(DISTINCT skills_job_dim.job_id) AS work_from_home_job_count
FROM skills_job_dim
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE job_postings_fact.job_work_from_home = TRUE
GROUP BY skills_job_dim.skill_id, skills_dim.skills
ORDER BY work_from_home_job_count DESC;


SELECT
    skills_dim.skills AS skill_name,
    COUNT(DISTINCT skills_job_dim.job_id) AS number_of_job_postings
FROM skills_job_dim 
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skill_id, skills_dim.skills
ORDER BY number_of_job_postings DESC
LIMIT 10;


with company_postings as (
select 
	company_dim.company_id,
	company_dim.name as company_name,
	count(distinct job_postings_fact.job_id) as total_job_postings
from
	job_postings_fact
inner join company_dim
	on job_postings_fact.company_id = company_dim.company_id
group by 
	company_dim.company_id,
	company_dim.name
)
select 
	company_name,
	total_job_postings,
	case
		when total_job_postings > 1000 then 'High_Hire'
		when total_job_postings between 500 and 1000 then 'Moderate_Hire'
		else 'Low_Hire'
	END AS hiring_category
from 
	company_postings
order by 
	total_job_postings desc;
	

with remote_job as (
select 	
	skill_id,
	count(*) as skills_count
from skills_job_dim
inner join job_postings_fact on skills_job_dim.job_id = job_postings_fact.job_id
where job_postings_fact.job_work_from_home = True
group by
	skill_id 
)
select 
	skills_dim.skill_id,
	skills_dim.skills,
	skills_count
from
	remote_job
inner join 
	skills_dim ON remote_job.skill_id = skills_dim.skill_id
order by 
	skills_count desc;

select 
 	job_id,
	job_title,
	job_location
from
	jan_job_postings
union
select 
 	job_id,
	job_title,
	job_location
from
	feb_job_posting;

--even duplicate 
select 
 	job_id,
	job_title,
	job_location
from
	jan_job_postings
union all
select 
 	job_id,
	job_title,
	job_location
from
	feb_job_posting;


select 
 	job_id,
	job_title,
	job_location,
	job_posted_date:: date,
	salary_year_avg 
from (
	select 
 	*
from
	jan_job_postings
union
select 
 	*
from
	feb_job_posting 
)
where 
	salary_year_avg > 7000 AND 
	job_title = 'Data Analyst'
order by
	salary_year_avg desc;



	
	


    

