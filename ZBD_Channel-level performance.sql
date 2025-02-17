WITH campaign_spend AS (
    SELECT 
        CAMPAIGN,
        SUM(SPEND) AS total_spend
    FROM ADITYAA.ZBD.MARKETING_SPEND
    GROUP BY CAMPAIGN
),
campaign_conversions AS (
    SELECT 
        CAMPAIGN,
        COUNT(USER_ID) AS total_conversions
    FROM ADITYAA.ZBD.USER_TOUCHPOINTS
    WHERE CONVERSION = TRUE
    GROUP BY CAMPAIGN
),
campaign_revenue AS (
    SELECT 
        u.CAMPAIGN,
        SUM(r.REVENUE) AS total_revenue
    FROM ADITYAA.ZBD.REVENUE_AND_REWARDS r
    INNER JOIN ADITYAA.ZBD.USER u ON r.USER_ID = u.USER_ID
    GROUP BY u.CAMPAIGN
)
SELECT 
    COALESCE(s.CAMPAIGN, c.CAMPAIGN, r.CAMPAIGN) AS CAMPAIGN,
    COALESCE(s.total_spend, 0) AS total_spend,
    COALESCE(c.total_conversions, 0) AS total_conversions,
    COALESCE(r.total_revenue, 0) AS total_revenue,
    CASE 
        WHEN COALESCE(s.total_spend, 0) > 0 THEN COALESCE(r.total_revenue, 0) / COALESCE(s.total_spend, 0)
        ELSE NULL
    END AS ROAS
FROM campaign_spend s
FULL OUTER JOIN campaign_conversions c ON s.CAMPAIGN = c.CAMPAIGN
FULL OUTER JOIN campaign_revenue r ON COALESCE(s.CAMPAIGN, c.CAMPAIGN) = r.CAMPAIGN;
