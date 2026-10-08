-- Sign-ups per day and verification rate.
-- Source: app database (PostgreSQL), table `users`. Returns counts only, never emails.
SELECT
    date_trunc('day', created_at)::date               AS signup_day,
    COUNT(*)                                          AS signups,
    COUNT(*) FILTER (WHERE email_verified)            AS verified,
    ROUND(100.0 * COUNT(*) FILTER (WHERE email_verified) / COUNT(*), 1) AS verified_pct
FROM users
GROUP BY 1
ORDER BY 1;
