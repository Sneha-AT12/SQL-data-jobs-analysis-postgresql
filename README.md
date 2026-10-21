<h1 align="center">🗄️ Data Jobs SQL Analysis (PostgreSQL)</h1>

<p align="center">
  <b>Which skills pay the most, which skills are most requested, and who is hiring?</b><br>
  A SQL project using PostgreSQL: joins, CTEs, subqueries, CASE, date functions and UNION.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-Database-336791?logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/SQL-Queries-4C72B0" alt="SQL">
  <img src="https://img.shields.io/badge/pgAdmin-Client-F37626" alt="pgAdmin">
</p>

<hr>

<h2>📑 Table of Contents</h2>

<ol>
  <li><a href="#overview">Overview</a><br></li>
  <li><a href="#questions">The Questions</a><br></li>
  <li><a href="#tools">Tools I Used</a><br></li>
  <li><a href="#database">Database Setup</a><br></li>
  <li><a href="#analysis">The Analysis</a><br></li>
  <li><a href="#learned">What I Learned</a><br></li>
  <li><a href="#challenges">Challenges I Faced</a><br></li>
  <li><a href="#run">How to Run This Project</a><br></li>
  <li><a href="#acknowledgements">Acknowledgements</a><br></li>
  <li><a href="#conclusion">Conclusion</a></li>
</ol>

<hr>

<h1 id="overview">🔎 Overview</h1>

<h3>Welcome to my SQL analysis of the data job market.</h3>

<p>
This project uses <b>PostgreSQL</b> to explore job postings, companies and skills.
I loaded four CSV files into a relational database, then wrote queries to find which skills are in demand,
which skills are linked to higher salaries, which companies hire the most, and how remote jobs differ.
</p>

<br>

<h1 id="questions">❓ The Questions</h1>

<ol>
  <li><b>Which skills are linked to the highest average salary?</b></li>
  <br>
  <li><b>What are the top 10 most requested skills?</b></li>
  <br>
  <li><b>What are the top skills for remote (work from home) jobs?</b></li>
  <br>
  <li><b>Which companies hire the most, and how can they be grouped?</b></li>
  <br>
  <li><b>Which companies post jobs that do not require a degree?</b></li>
  <br>
  <li><b>How do jobs split into Remote, Local and Onsite, and into salary levels?</b></li>
  <br>
  <li><b>Which Data Analyst jobs in January and February pay above a given salary?</b></li>
</ol>

<br>

<h1 id="tools">🛠️ Tools I Used</h1>

<table align="center">
  <thead>
    <tr><th align="left">Tool / Feature</th><th align="left">Purpose</th></tr>
  </thead>
  <tbody>
    <tr><td><b>🐘 PostgreSQL</b></td><td>The relational database</td></tr>
    <tr><td><b>🖥️ pgAdmin</b></td><td>Writing and running queries</td></tr>
    <tr><td><b>📥 COPY</b></td><td>Loading the CSV files into tables</td></tr>
    <tr><td><b>🔗 JOINs</b></td><td>Combining skills, jobs and companies</td></tr>
    <tr><td><b>🧩 CTEs and subqueries</b></td><td>Breaking complex logic into steps</td></tr>
    <tr><td><b>🔀 CASE</b></td><td>Creating categories (location, salary, hiring level)</td></tr>
    <tr><td><b>📅 EXTRACT / date functions</b></td><td>Splitting jobs by month</td></tr>
    <tr><td><b>➕ UNION / UNION ALL</b></td><td>Combining monthly tables</td></tr>
    <tr><td><b>🔀 Git &amp; GitHub</b></td><td>Version control and sharing the project</td></tr>
  </tbody>
</table>

<br>

<h1 id="database">🧱 Database Setup</h1>

<p>The database has <b>four tables</b>:</p>

<table align="center">
  <thead>
    <tr><th align="left">Table</th><th align="left">Description</th></tr>
  </thead>
  <tbody>
    <tr><td><code>company_dim</code></td><td>Company details</td></tr>
    <tr><td><code>skills_dim</code></td><td>List of skills</td></tr>
    <tr><td><code>job_postings_fact</code></td><td>Job postings with title, location, salary and dates</td></tr>
    <tr><td><code>skills_job_dim</code></td><td>Links each job to its skills</td></tr>
  </tbody>
</table>

<details>
  <summary><b>👉 Click to see how I loaded the data</b></summary>
  <br>

```sql
COPY public.company_dim
FROM 'D:/Co/SQL/bootcamp/csv_files/company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
```

<p>I loaded the tables in this order: <code>company_dim</code>, <code>skills_dim</code>, <code>job_postings_fact</code>, <code>skills_job_dim</code>. The same <code>COPY</code> command is used for each file.</p>

</details>

<br>

<h1 id="analysis">📈 The Analysis</h1>

<h2>1️⃣ Which skills are linked to the highest average salary?</h2>

<p>I joined the three tables and calculated the average yearly salary for each skill.</p>

<details>
  <summary><b>👉 Click to see the code</b></summary>
  <br>

```sql
SELECT
    skills_dim.skills                       AS skill,
    COUNT(skills_job_dim.skill_id)          AS number_of_job_postings,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM skills_dim
LEFT JOIN skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
GROUP BY skills_dim.skills
ORDER BY avg_salary DESC NULLS LAST;
```

</details>

<p align="center">
  <img src="images/1_skills_avg_salary.png" width="750" alt="Output: skills by average salary">
</p>
<p align="center"><i>Output: skills ranked by average salary.</i></p>

<hr>

<h2>2️⃣ What are the top 10 most requested skills?</h2>

<details>
  <summary><b>👉 Click to see the code</b></summary>
  <br>

```sql
SELECT
    skills_dim.skills AS skill_name,
    COUNT(DISTINCT skills_job_dim.job_id) AS number_of_job_postings
FROM skills_job_dim
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skill_id, skills_dim.skills
ORDER BY number_of_job_postings DESC
LIMIT 10;
```

</details>

<p align="center">
  <img src="images/2_top_10_skills.png" width="650" alt="Output: top 10 skills">
</p>
<p align="center"><i>Output: the 10 skills that appear in the most job postings.</i></p>

<hr>

<h2>3️⃣ What are the top skills for remote jobs?</h2>

<p>I used a <b>CTE</b> to count skills only for jobs marked as work from home.</p>

<details>
  <summary><b>👉 Click to see the code</b></summary>
  <br>

```sql
WITH remote_job AS (
    SELECT
        skill_id,
        COUNT(*) AS skills_count
    FROM skills_job_dim
    INNER JOIN job_postings_fact
        ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE job_postings_fact.job_work_from_home = TRUE
    GROUP BY skill_id
)
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    remote_job.skills_count
FROM remote_job
INNER JOIN skills_dim
    ON remote_job.skill_id = skills_dim.skill_id
ORDER BY remote_job.skills_count DESC;
```

</details>

<p align="center">
  <img src="images/3_remote_skills.png" width="650" alt="Output: top skills for remote jobs">
</p>
<p align="center"><i>Output: skills ranked by number of remote job postings.</i></p>

<hr>

<h2>4️⃣ Which companies hire the most?</h2>

<p>I counted postings per company in a CTE, then used <code>CASE</code> to group companies into hiring levels.</p>

<details>
  <summary><b>👉 Click to see the code</b></summary>
  <br>

```sql
WITH company_postings AS (
    SELECT
        company_dim.company_id,
        company_dim.name AS company_name,
        COUNT(DISTINCT job_postings_fact.job_id) AS total_job_postings
    FROM job_postings_fact
    INNER JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    GROUP BY company_dim.company_id, company_dim.name
)
SELECT
    company_name,
    total_job_postings,
    CASE
        WHEN total_job_postings > 1000 THEN 'High_Hire'
        WHEN total_job_postings BETWEEN 500 AND 1000 THEN 'Moderate_Hire'
        ELSE 'Low_Hire'
    END AS hiring_category
FROM company_postings
ORDER BY total_job_postings DESC;
```

</details>

<p align="center">
  <img src="images/4_company_hiring.png" width="650" alt="Output: companies by hiring category">
</p>
<p align="center"><i>Output: companies ranked by postings, with a hiring category.</i></p>

<hr>

<h2>5️⃣ Which companies post jobs with no degree requirement?</h2>

<p>I used a <b>subquery</b> with <code>IN</code> to find these companies.</p>

<details>
  <summary><b>👉 Click to see the code</b></summary>
  <br>

```sql
SELECT
    company_id,
    name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = TRUE
);
```

</details>

<hr>

<h2>6️⃣ How do jobs split into location and salary categories?</h2>

<p>I used <code>CASE</code> to label each Data Analyst job as Remote, Local or Onsite, and each salary as high, standard, low or unspecified.</p>

<details>
  <summary><b>👉 Click to see the code</b></summary>
  <br>

```sql
-- Location category
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere'    THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;

-- Salary category
SELECT
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 100000 THEN 'high'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'standard'
        WHEN salary_year_avg < 60000 THEN 'low'
        ELSE 'unspecified'
    END AS salary_category
FROM job_postings_fact;
```

</details>

<p align="center">
  <img src="images/5_location_category.png" width="500" alt="Output: jobs by location category">
</p>
<p align="center"><i>Output: Data Analyst jobs split into Remote, Local and Onsite.</i></p>

<hr>

<h2>7️⃣ Monthly job tables and UNION</h2>

<p>I split the postings into one table per month with <code>EXTRACT(MONTH ...)</code>, then combined January and February with <code>UNION</code> to filter high-paying Data Analyst jobs.</p>

<details>
  <summary><b>👉 Click to see the code</b></summary>
  <br>

```sql
DROP TABLE IF EXISTS jan_job_postings;
CREATE TABLE jan_job_postings AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

DROP TABLE IF EXISTS feb_job_postings;
CREATE TABLE feb_job_postings AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- Data Analyst jobs above 70,000 in January and February
SELECT
    job_id,
    job_title,
    job_location,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT * FROM jan_job_postings
    UNION
    SELECT * FROM feb_job_postings
) AS jan_feb_postings
WHERE salary_year_avg > 70000
  AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;
```

</details>

<p>
<b>UNION vs. UNION ALL:</b> <code>UNION</code> removes duplicate rows, while <code>UNION ALL</code> keeps every row.
</p>

<p align="center">
  <img src="images/6_union_output.png" width="750" alt="Output: high paying Data Analyst jobs in January and February">
</p>
<p align="center"><i>Output: high-paying Data Analyst jobs posted in January or February.</i></p>

<br>

<h1 id="learned">🎓 What I Learned</h1>

<ol>
  <li><b>Joins:</b> combining several tables to connect jobs, skills and companies.</li>
  <br>
  <li><b>CTEs and subqueries:</b> breaking a hard question into small, readable steps.</li>
  <br>
  <li><b>CASE:</b> turning raw values into clear categories.</li>
  <br>
  <li><b>Date functions:</b> using <code>EXTRACT</code> to analyze by month.</li>
  <br>
  <li><b>Data loading:</b> using <code>COPY</code> and checking tables, schemas and permissions.</li>
</ol>

<br>

<h1 id="challenges">🧗 Challenges I Faced</h1>

<ol>
  <li><b>Loading CSV files:</b> <code>COPY</code> reads files on the server, so file paths and permissions caused errors.</li>
  <br>
  <li><b>Syntax errors:</b> stray text, missing aliases on subqueries and trailing commas stopped queries.</li>
  <br>
  <li><b>Consistent names:</b> monthly tables must be named the same way when they are created and queried.</li>
  <br>
  <li><b>NULL salaries:</b> skills without salary data sort first in descending order, so I used <code>NULLS LAST</code>.</li>
</ol>

<br>

<h1 id="run">▶️ How to Run This Project</h1>

<ol>
  <li>Install <b>PostgreSQL</b> and <b>pgAdmin</b>.</li>
  <br>
  <li>Create a database and the four tables.</li>
  <br>
  <li>Download the data files from the course page (see Acknowledgements) and load them with <code>COPY</code> or the pgAdmin Import tool.</li>
  <br>
  <li>Open <code>sql/queries.sql</code> in pgAdmin, select one query at a time, and press <b>F5</b>.</li>
</ol>

<h3>📁 Project Structure</h3>

```text
📦 sql-data-jobs-analysis-postgresql
 ┣ 📂 images/
 ┃ ┣ 🖼️ 1_skills_avg_salary.png
 ┃ ┣ 🖼️ 2_top_10_skills.png
 ┃ ┣ 🖼️ 3_remote_skills.png
 ┃ ┣ 🖼️ 4_company_hiring.png
 ┃ ┣ 🖼️ 5_location_category.png
 ┃ ┗ 🖼️ 6_union_output.png
 ┣ 📂 sql/
 ┃ ┗ 📄 queries.sql
 ┗ 📄 README.md
```

<br>

<h1 id="acknowledgements">🙏 Acknowledgements</h1>

<p>
I completed the <b>SQL for Data Analytics</b> course by
<a href="https://lukebarousse.com">Luke Barousse</a>, and this project is the result of what I learned.
The dataset comes from the course and is not included in this repository.
The queries, analysis and written explanations are my own work.
</p>

<br>

<h1 id="conclusion">✅ Conclusion</h1>

<p>
This project shows how SQL can answer real hiring questions: which skills pay well, which are most requested, and which companies hire the most.
It covers the core tools of everyday data analysis: joins, aggregation, CTEs, subqueries, CASE and set operations.
</p>

<hr>

<p align="center">⭐ If you found this project useful, please consider giving it a star!</p>
