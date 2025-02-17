-- Creating the Users table
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    installed_at DATETIME2,
    created_at DATE,
    updated_at DATETIME2,
    channel VARCHAR(255),
    campaign VARCHAR(255)
);

-- Creating the Marketing Spend table
CREATE TABLE marketing_spend (
    date DATE,
    channel VARCHAR(255),
    campaign VARCHAR(255),
    spend DECIMAL(10,2),
    impressions INT,
    clicks INT,
    installs INT,
    PRIMARY KEY (date, channel, campaign)
);

-- Creating the User Touchpoints table
CREATE TABLE user_touchpoints (
    user_id VARCHAR(50),
    touchpoint_date DATETIME2,
    channel VARCHAR(255),
    campaign VARCHAR(255),
    touchpoint_type VARCHAR(50), -- e.g., ad_impression, ad_click
    source VARCHAR(255),
    medium VARCHAR(255),
    conversion BIT, -- Use BIT for Boolean in SQL Server
    PRIMARY KEY (user_id, touchpoint_date),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Creating the Revenue and Rewards table
CREATE TABLE revenue_and_rewards (
    user_id VARCHAR(50),
    date DATE,
    revenue DECIMAL(10,2),
    reward_to_user DECIMAL(10,8), -- Storing Bitcoin rewards
    PRIMARY KEY (user_id, date),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);