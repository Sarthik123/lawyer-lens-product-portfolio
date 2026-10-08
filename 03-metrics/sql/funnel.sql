-- Upload funnel: events and unique visitors per step, plus visitors and sessions overall.
-- Source: PostHog event export loaded as table `events`.
-- 7–8 Oct 2026 result: 6 visitors, 15 sessions; 17 upload_started, 8 upload_failed (47%),
-- 3 analysis_completed, 18 results_viewed, 70 question_asked.
SELECT 'all_visitors' AS step,
       COUNT(*) AS events,
       COUNT(DISTINCT person_id) AS visitors,
       COUNT(DISTINCT session_id) AS sessions
FROM events
UNION ALL
SELECT event,
       COUNT(*),
       COUNT(DISTINCT person_id),
       COUNT(DISTINCT session_id)
FROM events
WHERE event IN ('upload_started', 'upload_failed', 'analysis_completed',
                'results_viewed', 'question_asked')
GROUP BY event;

-- Upload failure rate by device.
SELECT
    device,
    SUM(CASE WHEN event = 'upload_started' THEN 1 ELSE 0 END) AS started,
    SUM(CASE WHEN event = 'upload_failed'  THEN 1 ELSE 0 END) AS failed,
    ROUND(100.0 * SUM(CASE WHEN event = 'upload_failed' THEN 1 ELSE 0 END)
          / NULLIF(SUM(CASE WHEN event = 'upload_started' THEN 1 ELSE 0 END), 0), 1) AS failure_pct
FROM events
GROUP BY device;
