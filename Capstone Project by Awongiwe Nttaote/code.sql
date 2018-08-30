/*first_touch query*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
Limit 10;
 
/*last_touch query*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
Limit 10;

/*QUESTION 1*/

SELECT COUNT(DISTINCT utm_campaign) AS 'Campaigns'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'Sources'
FROM page_visits;

SELECT DISTINCT utm_campaign AS 'Campaigns', 
		utm_source AS 'Sources'
FROM page_visits;

/*QUESTION 2*/

SELECT page_name
FROM page_visits
GROUP BY 1;

SELECT COUNT(DISTINCT page_name)
FROM page_visits;

/*QUESTION 3*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'Sources',
	ft_attr.utm_campaign AS 'Campaigns',
	COUNT (*) AS 'Total First Touches'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*QUESTION 4*/

WITH last_touch AS (
   SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Sources',
       lt_attr.utm_campaign AS 'Campaigns',
       COUNT(*) AS 'Total Last Touches'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*QUESTION 5*/

SELECT COUNT(DISTINCT user_id) AS 'Total Purchases'
FROM page_visits
WHERE page_name = '4 - purchase';

/*QUESTION 6*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase' 
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Sources',
       lt_attr.utm_campaign AS 'Campaigns',
       COUNT(*) AS 'Total Last Touches'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
