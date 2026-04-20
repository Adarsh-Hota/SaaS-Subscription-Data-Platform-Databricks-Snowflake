CREATE OR REPLACE VIEW ANALYTICS.SAAS_METRICS.SUBSCRIPTION_GROWTH AS
SELECT
    metric_date,
    new_subscriptions,
    cancellations,
    (new_subscriptions - cancellations) AS net_growth
FROM
    DAILY_ACTIVITY_METRICS;
