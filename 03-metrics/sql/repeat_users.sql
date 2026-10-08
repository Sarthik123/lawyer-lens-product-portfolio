-- Repeat users: visitors active on more than one day, and visitors with more than one session.
-- Source: PostHog event export loaded as table `events`.
-- 7–8 Oct 2026 result: 1 of 6 visitors active on 2 days.
WITH per_person AS (
    SELECT
        person_id,
        COUNT(DISTINCT day)        AS active_days,
        COUNT(DISTINCT session_id) AS sessions
    FROM events
    GROUP BY person_id
)
SELECT
    COUNT(*)                                          AS visitors,
    SUM(CASE WHEN active_days > 1 THEN 1 ELSE 0 END)  AS repeat_by_day,
    SUM(CASE WHEN sessions > 1 THEN 1 ELSE 0 END)     AS repeat_by_session
FROM per_person;
