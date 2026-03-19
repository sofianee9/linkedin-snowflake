import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()
st.title("Repartition des offres par type de travail")

df = session.sql("""
    SELECT
      CASE work_type
        WHEN 'REMOTE'    THEN 'Teletravail'
        WHEN 'HYBRID'    THEN 'Hybride'
        WHEN 'ON_SITE'   THEN 'Presentiel'
        WHEN 'CONTRACT'  THEN 'Contrat'
        WHEN 'TEMPORARY' THEN 'Temporaire'
        WHEN 'VOLUNTEER' THEN 'Benevole'
        WHEN 'INTERNSHIP'THEN 'Stage'
        ELSE 'Non renseigne'
      END AS type_travail,
      COUNT(*) AS nb_offres
    FROM linkedin.raw.job_postings
    WHERE work_type IS NOT NULL
    GROUP BY work_type, type_travail
    ORDER BY nb_offres DESC
""").to_pandas()

st.bar_chart(data=df.set_index("TYPE_TRAVAIL"), y="NB_OFFRES")
st.dataframe(df)
