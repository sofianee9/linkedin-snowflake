-- ============================================================
-- 05_load.sql
-- Chargement des donnees depuis le stage S3 vers les tables
-- ============================================================

USE DATABASE linkedin;
USE SCHEMA raw;

-- Chargement des fichiers CSV
COPY INTO job_postings
  FROM @linkedin_stage/job_postings.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  ON_ERROR = 'CONTINUE';

COPY INTO benefits
  FROM @linkedin_stage/benefits.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  ON_ERROR = 'CONTINUE';

COPY INTO employee_counts
  FROM @linkedin_stage/employee_counts.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  ON_ERROR = 'CONTINUE';

COPY INTO job_skills
  FROM @linkedin_stage/job_skills.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  ON_ERROR = 'CONTINUE';

-- Chargement des fichiers JSON simples
COPY INTO companies
  FROM (
    SELECT $1:company_id::NUMBER, $1:name::VARCHAR, $1:description::VARCHAR,
           $1:company_size::NUMBER, $1:state::VARCHAR, $1:country::VARCHAR,
           $1:city::VARCHAR, $1:zip_code::VARCHAR, $1:address::VARCHAR, $1:url::VARCHAR
    FROM @linkedin_stage/companies.json
  )
  FILE_FORMAT = (FORMAT_NAME = json_format)
  ON_ERROR = 'CONTINUE';

COPY INTO job_industries
  FROM (
    SELECT $1:job_id::NUMBER, $1:industry_id::NUMBER
    FROM @linkedin_stage/job_industries.json
  )
  FILE_FORMAT = (FORMAT_NAME = json_format)
  ON_ERROR = 'CONTINUE';

-- Chargement des fichiers JSON plats (une cle par ligne)
COPY INTO company_industries
  FROM (
    SELECT $1:company_id::NUMBER, $1:industry::VARCHAR
    FROM @linkedin_stage/company_industries.json
  )
  FILE_FORMAT = (FORMAT_NAME = json_format)
  ON_ERROR = 'CONTINUE';

COPY INTO company_specialities
  FROM (
    SELECT $1:company_id::VARCHAR, $1:speciality::VARCHAR
    FROM @linkedin_stage/company_specialities.json
  )
  FILE_FORMAT = (FORMAT_NAME = json_format)
  ON_ERROR = 'CONTINUE';

-- Verification du chargement
SELECT 'job_postings'         AS table_name, COUNT(*) AS nb_lignes FROM job_postings         UNION ALL
SELECT 'benefits',                            COUNT(*)              FROM benefits              UNION ALL
SELECT 'employee_counts',                     COUNT(*)              FROM employee_counts       UNION ALL
SELECT 'job_skills',                          COUNT(*)              FROM job_skills            UNION ALL
SELECT 'companies',                           COUNT(*)              FROM companies             UNION ALL
SELECT 'company_industries',                  COUNT(*)              FROM company_industries    UNION ALL
SELECT 'company_specialities',                COUNT(*)              FROM company_specialities  UNION ALL
SELECT 'job_industries',                      COUNT(*)              FROM job_industries;
