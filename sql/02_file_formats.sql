-- ============================================================
-- 02_file_formats.sql
-- Definition des formats de fichiers CSV et JSON
-- ============================================================

USE DATABASE linkedin;
USE SCHEMA raw;

-- Format CSV : separateur virgule, ignore la premiere ligne (header)
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('NULL', 'null', '')
  EMPTY_FIELD_AS_NULL = TRUE;

-- Format JSON : un objet JSON par ligne
CREATE OR REPLACE FILE FORMAT json_format
  TYPE = JSON
  STRIP_OUTER_ARRAY = FALSE;
