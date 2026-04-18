-- 1-mashq
WITH streaks AS (
    SELECT 
        user_id,
        match_date,
        result,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY match_date) AS rn_all,
        ROW_NUMBER() OVER (PARTITION BY user_id, result ORDER BY match_date) AS rn_result
    FROM matches
)
SELECT 
    user_id,
    MAX(streak) AS longest_win_streak
FROM (
    SELECT 
        user_id,
        result,
        COUNT(*) AS streak
    FROM streaks
    WHERE result = 'win'
    GROUP BY user_id, (rn_all - rn_result)
) t
GROUP BY user_id;
-- 2-mashq
WITH RECURSIVE hierarchy AS (
    SELECT id, name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, h.level + 1
    FROM employees e
    JOIN hierarchy h ON e.manager_id = h.id
)
SELECT id, name, manager_id, level
FROM hierarchy
ORDER BY level, id;
