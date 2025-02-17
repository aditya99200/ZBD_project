-- Convert revenue and rewards to the correct numeric type
WITH revenue_rewards AS (
    SELECT 
        USER_ID, 
        CAST(REVENUE AS DOUBLE) AS revenue, 
        CAST(REWARD_TO_USER AS DOUBLE) AS reward_to_user
    FROM ADITYAA.ZBD.REVENUE_AND_REWARDS
),
user_revenue AS (
    -- Aggregate total revenue & rewards per user
    SELECT 
        USER_ID,
        SUM(revenue) AS total_revenue,
        SUM(reward_to_user) AS total_rewards
    FROM revenue_rewards
    GROUP BY USER_ID
),
user_touchpoints AS (
    -- Count number of touchpoints per user
    SELECT 
        USER_ID, 
        COUNT(TOUCHPOINT_DATE) AS num_touchpoints
    FROM ADITYAA.ZBD.USER_TOUCHPOINTS
    GROUP BY USER_ID
)
SELECT 
    u.USER_ID,
    u.INSTALLED_AT,
    u.CREATED_AT,
    u.UPDATED_AT,
    u.CHANNEL,
    u.CAMPAIGN,
    COALESCE(ur.total_revenue, 0) AS total_revenue,
    COALESCE(ur.total_rewards, 0) AS total_rewards,
    COALESCE(ut.num_touchpoints, 0) AS num_touchpoints
FROM ADITYAA.ZBD.USER u
LEFT JOIN user_revenue ur ON u.USER_ID = ur.USER_ID
LEFT JOIN user_touchpoints ut ON u.USER_ID = ut.USER_ID;
