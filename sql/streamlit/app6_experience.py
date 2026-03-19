import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()
st.title("Repartition des offres par niveau d'experience")

df = session.sql("""
    SELECT
      CASE formatted_experience_level
        WHEN 'INTERNSHIP'   THEN 'Stage'
        WHEN 'ENTRY_LEVEL'  THEN 'Debutant'
        WHEN 'ASSOCIATE'    THEN 'Confirme'
        WHEN 'MID_SENIOR'   THEN 'Senior'
        WHEN 'DIRECTOR'     THEN 'Directeur'
        WHEN 'EXECUTIVE'    THEN 'Executif'
        ELSE 'Non renseigne'
      END AS niveau,
      COUNT(*) AS nb_offres
    FROM linkedin.raw.job_postings
    WHERE formatted_experience_level IS NOT NULL
    GROUP BY formatted_experience_level, niveau
    ORDER BY nb_offres DESC
""").to_pandas()

st.bar_chart(data=df.set_index("NIVEAU"), y="NB_OFFRES")
st.dataframe(df)
