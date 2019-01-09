SELECT COUNT (DISTINCT utm_campaign) AS Number_of_Campaigns,
 	COUNT (DISTINCT utm_source) AS Number_of_Sources
FROM page_visits;
 
SELECT DISTINCT utm_Campaign AS Campaign_Name, 
	UTM_source AS Source_Name
FROM page_visits;

SELECT DISTINCT page_name AS Web_Page_Name
FROM page_visits;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
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
    	AND ft.first_touch_at = pv.timestamp)
SELECT ft_attr.utm_source AS First_Touch_Source,
       ft_attr.utm_campaign AS First_Touch_Campaign,
       COUNT(*) AS Number_of_First_Touches
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source AS Last_Touch_Source,
       lt_attr.utm_campaign AS Last_Touch_Campaign,
       COUNT(*) AS Number_of_Last_Touches
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT COUNT (DISTINCT user_id) AS Number_of_Visitors_Purchase
FROM page_visits
WHERE page_name = '4 - purchase';

WITH last_touch AS (
  SELECT user_id,
        MAX(timestamp) AS last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source AS Last_Touch_Source,
       lt_attr.utm_campaign AS Last_Touch_Campaign,
       COUNT(DISTINCT user_id) AS Purchases_From_Campaigns
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;