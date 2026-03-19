-- ============================================================
-- 01_setup.sql
-- Creation de la base de donnees, du schema et du warehouse
-- ============================================================

-- Base de donnees principale du projet
CREATE DATABASE IF NOT EXISTS linkedin;

-- Schema pour les donnees brutes
CREATE SCHEMA IF NOT EXISTS linkedin.raw;

-- Warehouse de calcul (taille XS suffisante pour ce projet)
USE WAREHOUSE COMPUTE_WH;
USE DATABASE linkedin;
USE SCHEMA raw;
