-- ============================================================
-- 03_stage.sql
-- Creation du stage externe pointant vers le bucket S3
-- ============================================================

USE DATABASE linkedin;
USE SCHEMA raw;

-- Stage externe S3 public (pas de credentials necessaires)
CREATE OR REPLACE STAGE linkedin_stage
  URL = 's3://snowflake-lab-bucket/'
  FILE_FORMAT = csv_format;

-- Verification : liste les fichiers disponibles dans le bucket
LIST @linkedin_stage;
