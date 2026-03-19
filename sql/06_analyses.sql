-- ============================================================
-- 06_analyses.sql
-- Les 5 analyses SQL sur les donnees LinkedIn
-- ============================================================

USE DATABASE linkedin;
USE SCHEMA raw;

-- ------------------------------------------------------------
-- ANALYSE 1 : Top 10 des titres les plus publies par industrie
-- ------------------------------------------------------------
SELECT industry_id, title, nb_offres, rang
FROM (
  SELECT ji.industry_id, jp.title,
         COUNT(*) AS nb_offres,
         ROW_NUMBER() OVER (PARTITION BY ji.industry_id ORDER BY COUNT(*) DESC) AS rang
  FROM job_postings jp
  JOIN job_industries ji ON jp.job_id = ji.job_id
  WHERE jp.title IS NOT NULL
  GROUP BY ji.industry_id, jp.title
)
WHERE rang <= 10
ORDER BY industry_id, rang;

-- ------------------------------------------------------------
-- ANALYSE 2 : Top 10 des postes les mieux remuneres par industrie
-- ------------------------------------------------------------
SELECT industry_id, title, max_salary, pay_period, rang
FROM (
  SELECT ji.industry_id, jp.title, jp.max_salary, jp.pay_period,
         ROW_NUMBER() OVER (PARTITION BY ji.industry_id ORDER BY jp.max_salary DESC) AS rang
  FROM job_postings jp
  JOIN job_industries ji ON jp.job_id = ji.job_id
  WHERE jp.max_salary IS NOT NULL
)
WHERE rang <= 10
ORDER BY industry_id, rang;

-- ------------------------------------------------------------
-- ANALYSE 3 : Repartition des entreprises par taille
-- ------------------------------------------------------------
SELECT
  CASE company_size
    WHEN 0 THEN '0 - Moins de 1 employe'
    WHEN 1 THEN '1 - 1 a 10'
    WHEN 2 THEN '2 - 11 a 50'
    WHEN 3 THEN '3 - 51 a 200'
    WHEN 4 THEN '4 - 201 a 500'
    WHEN 5 THEN '5 - 501 a 1000'
    WHEN 6 THEN '6 - 1001 a 5000'
    WHEN 7 THEN '7 - Plus de 5000'
    ELSE 'Non renseigne'
  END AS taille,
  COUNT(*) AS nb_entreprises
FROM companies
GROUP BY company_size, taille
ORDER BY company_size;

-- ------------------------------------------------------------
-- ANALYSE 4 : Top 20 des secteurs avec le plus d'entreprises
-- ------------------------------------------------------------
SELECT industry, COUNT(DISTINCT company_id) AS nb_entreprises
FROM company_industries
GROUP BY industry
ORDER BY nb_entreprises DESC
LIMIT 20;

-- ------------------------------------------------------------
-- ANALYSE 5 : Repartition des offres par type d'emploi
-- ------------------------------------------------------------
SELECT
  COALESCE(formatted_work_type, 'Non renseigne') AS type_emploi,
  COUNT(*) AS nb_offres,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pourcentage
FROM job_postings
GROUP BY formatted_work_type
ORDER BY nb_offres DESC;
