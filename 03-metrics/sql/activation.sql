-- Activation: visitors who viewed analysis results AND asked at least one question.
-- Source: PostHog event export loaded as table `events`
--   (day, event, person_id, session_id, page, device, browser, country, source).
-- 7–8 Oct 2026 result: 1 activated of 6 visitors.
WITH per_person AS (
    SELECT
        person_id,
        MAX(CASE WHEN event = 'results_viewed' THEN 1 ELSE 0 END) AS viewed_results,
        MAX(CASE WHEN event = 'question_asked' THEN 1 ELSE 0 END) AS asked_question
    FROM events
    GROUP BY person_id
)
SELECT
    COUNT(*)                                                    AS visitors,
    SUM(CASE WHEN viewed_results = 1 AND asked_question = 1 THEN 1 ELSE 0 END) AS activated,
    ROUND(100.0 * SUM(CASE WHEN viewed_results = 1 AND asked_question = 1 THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                        AS activation_pct
FROM per_person;
