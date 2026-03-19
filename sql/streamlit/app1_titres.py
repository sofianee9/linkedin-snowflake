import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()
st.title("Top 10 des titres les plus publies par industrie")

industries_df = session.sql("""
    SELECT ji.industry_id, COUNT(*) AS nb_offres
    FROM linkedin.raw.job_industries ji
    GROUP BY ji.industry_id
    ORDER BY nb_offres DESC
""").to_pandas()

industries_df["LABEL"] = "ID " + industries_df["INDUSTRY_ID"].astype(str) + " (" + industries_df["NB_OFFRES"].astype(str) + " offres)"
label_to_id = dict(zip(industries_df["LABEL"], industries_df["INDUSTRY_ID"]))

selected_label = st.selectbox("Choisir une industrie :", list(label_to_id.keys()))
selected_id = label_to_id[selected_label]

df = session.sql(f"""
    SELECT title, nb_offres FROM (
      SELECT jp.title, COUNT(*) AS nb_offres,
             ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rang
      FROM linkedin.raw.job_postings jp
      JOIN linkedin.raw.job_industries ji ON jp.job_id = ji.job_id
      WHERE ji.industry_id = {selected_id} AND jp.title IS NOT NULL
      GROUP BY jp.title
    ) WHERE rang <= 10
    ORDER BY nb_offres DESC
""").to_pandas()

st.bar_chart(data=df.set_index("TITLE"), y="NB_OFFRES")
st.dataframe(df)
