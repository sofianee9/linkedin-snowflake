import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()
st.title("Repartition des entreprises par taille")

df = session.sql("""
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
    FROM linkedin.raw.companies
    GROUP BY company_size, taille
    ORDER BY company_size
""").to_pandas()

st.bar_chart(data=df.set_index("TAILLE"), y="NB_ENTREPRISES")
st.dataframe(df)
