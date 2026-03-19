import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()
st.title("Top 10 des postes les mieux remuneres par industrie")

industries_df = session.sql("""
    SELECT ji.industry_id, COUNT(*) AS nb_offres
    FROM linkedin.raw.job_industries ji
    JOIN linkedin.raw.job_postings jp ON ji.job_id = jp.job_id
    WHERE jp.max_salary IS NOT NULL
    GROUP BY ji.industry_id
    ORDER BY nb_offres DESC
""").to_pandas()

industries_df["LABEL"] = "ID " + industries_df["INDUSTRY_ID"].astype(str) + " (" + industries_df["NB_OFFRES"].astype(str) + " offres avec salaire)"
label_to_id = dict(zip(industries_df["LABEL"], industries_df["INDUSTRY_ID"]))

selected_label = st.selectbox("Choisir une industrie :", list(label_to_id.keys()))
selected_id = label_to_id[selected_label]

df = session.sql(f"""
    SELECT title, max_salary, pay_period FROM (
      SELECT jp.title, jp.max_salary, jp.pay_period,
             ROW_NUMBER() OVER (ORDER BY jp.max_salary DESC) AS rang
      FROM linkedin.raw.job_postings jp
      JOIN linkedin.raw.job_industries ji ON jp.job_id = ji.job_id
      WHERE ji.industry_id = {selected_id}
        AND jp.max_salary IS NOT NULL
    ) WHERE rang <= 10
    ORDER BY max_salary DESC
""").to_pandas()

st.bar_chart(data=df.set_index("TITLE"), y="MAX_SALARY")
st.dataframe(df)
