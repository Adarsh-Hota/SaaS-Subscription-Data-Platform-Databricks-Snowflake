CREATE OR REPLACE VIEW ANALYTICS.SAAS_METRICS.BUSINESS_DASHBOARD AS
SELECT
    d.metric_date,
    -- activity
    d.new_subscriptions,
    d.cancellations,
    d.plan_changes,
    -- state
    s.mrr,
    s.active_subscriptions,
    -- derived
    (d.new_subscriptions - d.cancellations) AS net_growth,
    CASE
        WHEN s.active_subscriptions = 0 THEN 0
        ELSE d.cancellations / s.active_subscriptions
    END AS churn_rate
FROM
    ANALYTICS.SAAS_METRICS.DAILY_ACTIVITY_METRICS d
    LEFT JOIN ANALYTICS.SAAS_METRICS.SUBSCRIPTION_KPIS_SNAPSHOT s 
    ON d.metric_date = s.snapshot_date;
