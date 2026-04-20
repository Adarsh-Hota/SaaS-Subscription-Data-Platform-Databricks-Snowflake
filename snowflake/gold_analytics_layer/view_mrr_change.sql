CREATE OR REPLACE VIEW ANALYTICS.SAAS_METRICS.MRR_CHANGE AS
SELECT
    snapshot_date,
    mrr,
    mrr - LAG(mrr) OVER (
        ORDER BY
            snapshot_date
    ) AS mrr_change
FROM
    ANALYTICS.SAAS_METRICS.SUBSCRIPTION_KPIS_SNAPSHOT;
