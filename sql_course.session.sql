CREATE TABLE job_applied(
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT * FROM job_applied;

INSERT INTO job_applied(
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES (
    1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'
);

INSERT INTO job_applied(
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES (
    2,
    '2024-02-02',
    false,
    'resume_02.pdf',
    true,
    'cover_letter_02.pdf',
    'submitted'
);

INSERT INTO job_applied(
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES (
    3,
    '2024-02-03',
    true,
    'resume_03.pdf',
    false,
    'cover_letter_03.pdf',
    'rejected'
);

INSERT INTO job_applied(
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    status
)
VALUES (
    4,
    '2024-02-04',
    false,
    'resume_04.pdf',
    false,
    'submitted'
);


INSERT INTO job_applied(
    job_id,
    application_sent_date,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES (
    2,
    '2024-02-02',
    false,
    true,
    'cover_letter_02.pdf',
    'submitted'
);


ALTER TABLE job_applied
ADD contact VARCHAR(50);

SELECT * FROM job_applied;

UPDATE job_applied
SET contact = 'Ipsita Gupta'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Amrita Gupta'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Ajoy Kumar Gupta'
WHERE job_id = 3;

UPDATE job_applied
SET contact = 'Mrinmoyee Das'
WHERE job_id = 4;

UPDATE job_applied
SET contact = 'Sammy'
WHERE job_id = 5;

SELECT * FROM job_applied;

UPDATE job_applied
SET contact = 'Sammy'
WHERE job_id = 5;

INSERT INTO job_applied(
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    status
)
VALUES (
    5,
    '2024-02-05',
    false,
    'resume_05.pdf',
    false,
    'rejected'
);

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;


ALTER TABLE job_applied
           DROP COLUMN contact_name;


SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

SELECT
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL; 

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact;

SELECT 
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
-- WHERE
--     job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    month;

SELECT
    AVG(salary_year_avg) AS year_avg,
    AVG(salary_hour_avg) AS hour_avg
FROM
    job_postings_fact
WHERE
    job_posted_date::DATE = '2023-06-01'
GROUP BY
    job_schedule_type;



-- SELECT * FROM job_postings_fact
-- LIMIT 5;


SELECT
    job_title_short,
    job_location
FROM job_postings_fact;

/*

Label new column as follows:
-'Anywhere' jobs as 'Remote'
-'New York, NY' jobs as 'Local'
-Otherwise 'Onsite'

*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location='Anywhere' THEN 'Remote'
        WHEN job_location='New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS job_location_description
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY job_location_description;

SELECT
    COUNT(job_id) AS no_of_jobs,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 50000 THEN 'High Salary'
        WHEN (salary_year_avg > 10000 OR salary_year_avg < 50000) THEN 'Medium Salary'
        ELSE 'Low Salaray'
    END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY salary_year_avg
ORDER BY salary_year_avg DESC;

-- January Table
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February Table
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March Table
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


SELECT * FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 
) AS january_jobs;

SELECT 
    company_id,
    job_no_degree_mention
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = true;

SELECT
    company_id,
    name AS company_name
FROM
    company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY
        company_id
);

/*
Find the companies that have the most job openings.
- Get the total number of job postings per company_id (job_postings_fact)
- Return the total number of jobs with the company name (company_dim)
*/

WITH company_job_count AS(
    SELECT
        company_id,
        COUNT(*)
    FROM
        job_postings_fact
    GROUP BY
        company_id   
) 

SELECT name
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_dim.company_id;

SELECT name
FROM company_dim;

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
UNION
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs;