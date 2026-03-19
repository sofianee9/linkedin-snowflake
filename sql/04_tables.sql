-- ============================================================
-- 04_tables.sql
-- Creation des 8 tables correspondant aux fichiers du bucket
-- ============================================================

USE DATABASE linkedin;
USE SCHEMA raw;

-- Table des offres d'emploi (fichier principal)
CREATE OR REPLACE TABLE job_postings (
  job_id NUMBER,
  company_name VARCHAR,
  title VARCHAR,
  description VARCHAR,
  max_salary FLOAT,
  med_salary FLOAT,
  min_salary FLOAT,
  pay_period VARCHAR,
  formatted_work_type VARCHAR,
  location VARCHAR,
  applies NUMBER,
  original_listed_time NUMBER,
  remote_allowed BOOLEAN,
  views NUMBER,
  job_posting_url VARCHAR,
  application_url VARCHAR,
  application_type VARCHAR,
  expiry NUMBER,
  closed_time NUMBER,
  formatted_experience_level VARCHAR,
  skills_desc VARCHAR,
  listed_time NUMBER,
  posting_domain VARCHAR,
  sponsored BOOLEAN,
  work_type VARCHAR,
  currency VARCHAR,
  compensation_type VARCHAR
);

-- Avantages associes aux offres
CREATE OR REPLACE TABLE benefits (
  job_id NUMBER,
  inferred BOOLEAN,
  type VARCHAR
);

-- Informations sur les entreprises
CREATE OR REPLACE TABLE companies (
  company_id NUMBER,
  name VARCHAR,
  description VARCHAR,
  company_size NUMBER,
  state VARCHAR,
  country VARCHAR,
  city VARCHAR,
  zip_code VARCHAR,
  address VARCHAR,
  url VARCHAR
);

-- Nombre d'employes et de followers par entreprise
CREATE OR REPLACE TABLE employee_counts (
  company_id NUMBER,
  employee_count NUMBER,
  follower_count NUMBER,
  time_recorded NUMBER
);

-- Competences associees aux offres
CREATE OR REPLACE TABLE job_skills (
  job_id NUMBER,
  skill_abr VARCHAR
);

-- Secteurs d'activite associes aux offres
CREATE OR REPLACE TABLE job_industries (
  job_id NUMBER,
  industry_id NUMBER
);

-- Secteurs d'activite associes aux entreprises
CREATE OR REPLACE TABLE company_industries (
  company_id NUMBER,
  industry VARCHAR
);

-- Specialites associees aux entreprises
CREATE OR REPLACE TABLE company_specialities (
  company_id VARCHAR,
  speciality VARCHAR
);
