-- Documents per user: distribution of how many documents each user has uploaded.
-- Source: app database (PostgreSQL), table `documents`. No file names or content selected.
WITH per_user AS (
    SELECT user_id, COUNT(*) AS documents
    FROM documents
    WHERE user_id IS NOT NULL
    GROUP BY user_id
)
SELECT
    documents                                              AS documents_uploaded,
    COUNT(*)                                               AS users,
    (SELECT ROUND(AVG(documents), 2) FROM per_user)        AS avg_docs_per_user
FROM per_user
GROUP BY documents
ORDER BY documents;
