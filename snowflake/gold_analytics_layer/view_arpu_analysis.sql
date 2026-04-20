CREATE OR REPLACE VIEW ANALYTICS.SAAS_METRICS.ARPU_ANALYSIS AS
SELECT
    snapshot_date,
    mrr,
    active_subscriptions,
    CASE
        WHEN active_subscriptions = 0 THEN 0
        ELSE mrr / active_subscriptions
    END AS arpu
FROM
    SUBSCRIPTION_KPIS_SNAPSHOT;
