# CIPDI Post-Program Survey Analysis

**Business question:** Did CIPDI's professional certificate program meet learner expectations, and what should be improved?

## Dashboard
[View the Tableau dashboard](https://public.tableau.com/app/profile/daniel.iwunze/viz/CIPDIPost-ProgramSurveyDashboard/Dashboard1)

## Data
- 154 anonymized survey responses across 7 course tracks
- Respondent names, emails and free-text answers are **not** included in this repository

## Tools
Excel (cleaning, pivot tables, charts, theme coding) | Tableau (dashboard) | SQL on BigQuery (validation)

## Process
1. **Cleaned** the raw responses in Excel: removed empty columns, checked for duplicates, left 2 missing values blank instead of guessing, and recorded every step in a cleaning log.
2. **Analyzed** with pivot tables and coded open-ended answers into themes.
3. **Visualized** the findings in a Tableau dashboard.
4. **Validated** the Excel results by reproducing them in SQL (`survey_analysis.sql`).

## Key findings
- Overall satisfaction: **4.53 / 5**; recommendation likelihood **4.65 / 5**
- Weakest rated area: **communication (4.29 / 5)**
- Learners most often said these needed improvement: onboarding session (49), Google Classroom submission (45), orientation (39)
- 59 of 154 respondents (38.3%) reported facing challenges
- 100% said they would be interested in future CIPDI programs

## SQL validation
`survey_analysis.sql` holds 12 queries run on BigQuery (sandbox) against an anonymized copy of the cleaned data. The results matched the Excel analysis (for example 154 respondents; 59 reporting challenges = 38.3%).

Note: BigQuery's schema auto-detect loaded the Yes/No columns as BOOLEAN, so the queries use `COUNTIF` instead of comparing to text.

## Repository contents
- `README.md` - this file
- `survey_analysis.sql` - SQL validation queries
