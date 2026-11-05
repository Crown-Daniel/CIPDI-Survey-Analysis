-- CIPDI Post-Program Survey: SQL validation of Excel findings
-- Table: `cipdi-survey-analysis.survey_data.survey` (anonymized: names, emails and free-text removed)
-- Written for BigQuery; also runs in SQLite if you swap in the plain table name `survey`.

-- Suggested columns (snake_case):
-- gender, course, completed_program, program_organization, communication,
-- content_relevance, learning_materials, expectations_met, knowledge_gained,
-- recommend_program, support_rating, faced_challenges, future_interest

-- 1. Total respondents (Excel: 154)
SELECT COUNT(*) AS total_respondents
FROM `cipdi-survey-analysis.survey_data.survey`;

-- 2. Average rating per evaluation area (Excel: 4.65, 4.62, 4.58, 4.55, 4.55, 4.49, 4.29)
SELECT 'Recommendation Likelihood' AS area, ROUND(AVG(recommend_program), 2) AS avg_rating FROM `cipdi-survey-analysis.survey_data.survey`
UNION ALL SELECT 'Content Relevance', ROUND(AVG(content_relevance), 2) FROM `cipdi-survey-analysis.survey_data.survey`
UNION ALL SELECT 'Knowledge Gained', ROUND(AVG(knowledge_gained), 2) FROM `cipdi-survey-analysis.survey_data.survey`
UNION ALL SELECT 'Learning Materials', ROUND(AVG(learning_materials), 2) FROM `cipdi-survey-analysis.survey_data.survey`
UNION ALL SELECT 'Program Organization', ROUND(AVG(program_organization), 2) FROM `cipdi-survey-analysis.survey_data.survey`
UNION ALL SELECT 'Expectations Met', ROUND(AVG(expectations_met), 2) FROM `cipdi-survey-analysis.survey_data.survey`
UNION ALL SELECT 'Communication', ROUND(AVG(communication), 2) FROM `cipdi-survey-analysis.survey_data.survey`
ORDER BY avg_rating DESC;

-- 3. Overall satisfaction = mean of the seven area averages (Excel: 4.53)
SELECT ROUND(AVG(avg_rating), 2) AS overall_satisfaction
FROM (
  SELECT AVG(recommend_program) AS avg_rating FROM `cipdi-survey-analysis.survey_data.survey`
  UNION ALL SELECT AVG(content_relevance) FROM `cipdi-survey-analysis.survey_data.survey`
  UNION ALL SELECT AVG(knowledge_gained) FROM `cipdi-survey-analysis.survey_data.survey`
  UNION ALL SELECT AVG(learning_materials) FROM `cipdi-survey-analysis.survey_data.survey`
  UNION ALL SELECT AVG(program_organization) FROM `cipdi-survey-analysis.survey_data.survey`
  UNION ALL SELECT AVG(expectations_met) FROM `cipdi-survey-analysis.survey_data.survey`
  UNION ALL SELECT AVG(communication) FROM `cipdi-survey-analysis.survey_data.survey`
) t;

-- 4. Support rating out of 10 (Excel: 8.55)
SELECT ROUND(AVG(support_rating), 2) AS avg_support_rating
FROM `cipdi-survey-analysis.survey_data.survey`;

-- 5. Recommendation: share of 5s and share of 4-5s (expected: 77.9% and 87.0%)
SELECT
  ROUND(100.0 * AVG(CASE WHEN recommend_program = 5 THEN 1 ELSE 0 END), 1) AS pct_rated_5,
  ROUND(100.0 * AVG(CASE WHEN recommend_program >= 4 THEN 1 ELSE 0 END), 1) AS pct_rated_4_or_5
FROM `cipdi-survey-analysis.survey_data.survey`;

-- 6. Knowledge gained: share of 4-5s (expected: 85.7%)
SELECT ROUND(100.0 * AVG(CASE WHEN knowledge_gained >= 4 THEN 1 ELSE 0 END), 1) AS pct_knowledge_4_or_5
FROM `cipdi-survey-analysis.survey_data.survey`;

-- 7. Respondents and average satisfaction by course track
SELECT course,
       COUNT(*) AS respondents,
       ROUND(AVG(recommend_program), 2) AS avg_recommend,
       ROUND(AVG(knowledge_gained), 2) AS avg_knowledge
FROM `cipdi-survey-analysis.survey_data.survey`
GROUP BY course
ORDER BY respondents DESC;

-- 8. Completion rate, excluding the one blank response (expected: 145 of 153 = 94.8%)
-- Note: BigQuery auto-detected the Yes/No columns as BOOLEAN, so COUNTIF is used.
SELECT
  COUNTIF(completed_program) AS completed,
  COUNT(completed_program) AS answered,
  ROUND(100 * COUNTIF(completed_program) / COUNT(completed_program), 1) AS completion_pct
FROM `cipdi-survey-analysis.survey_data.survey`;

-- 9. Share who faced challenges (expected: 59 of 154 = 38.3%)
SELECT
  COUNTIF(faced_challenges) AS faced_challenges,
  ROUND(100 * COUNTIF(faced_challenges) / COUNT(*), 1) AS challenge_pct
FROM `cipdi-survey-analysis.survey_data.survey`;

-- 10. Future interest in CIPDI programs (expected: TRUE = 154)
SELECT future_interest, COUNT(*) AS respondents
FROM `cipdi-survey-analysis.survey_data.survey`
GROUP BY future_interest;

-- 11. Data quality check: missing completed_program values (expected: 1)
SELECT COUNT(*) - COUNT(completed_program) AS missing_completed_program
FROM `cipdi-survey-analysis.survey_data.survey`;

-- 12. Where learners say the program needs improvement (Excel themes: onboarding 49, Classroom submission 45, orientation 39, Coursera 21)
SELECT needs_improvement, COUNT(*) AS respondents
FROM `cipdi-survey-analysis.survey_data.survey`
GROUP BY needs_improvement
ORDER BY respondents DESC;
