CREATE OR REPLACE VIEW ANALYTICS.SAAS_METRICS.CHURN_ANALYSIS AS
SELECT
    d.metric_date,
    d.cancellations,
    s.active_subscriptions,
    CASE
        WHEN s.active_subscriptions = 0 THEN 0
        ELSE d.cancellations / s.active_subscriptions
    END AS churn_rate
FROM
    ANALYTICS.SAAS_METRICS.DAILY_ACTIVITY_METRICS d
    JOIN ANALYTICS.SAAS_METRICS.SUBSCRIPTION_KPIS_SNAPSHOT s 
    ON d.metric_date = s.snapshot_date;
