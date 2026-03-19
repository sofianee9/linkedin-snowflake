import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()
st.title("Top 20 des secteurs avec le plus d'entreprises")

df = session.sql("""
    SELECT industry, COUNT(DISTINCT company_id) AS nb_entreprises
    FROM linkedin.raw.company_industries
    GROUP BY industry
    ORDER BY nb_entreprises DESC
    LIMIT 20
""").to_pandas()

st.bar_chart(data=df.set_index("INDUSTRY"), y="NB_ENTREPRISES")
st.dataframe(df)
