# Subscription Revenue Data Platform

## 📌 Overview

This project simulates a SaaS subscription platform and builds an end-to-end data pipeline to process subscription events into analytics-ready datasets.

It demonstrates modern data engineering practices including streaming ingestion, CDC-based modeling, medallion architecture, and cross-platform analytics using AWS, Databricks, and Snowflake.

---

## 🏗️ Architecture

![Architecture](images/architecture/architecture_diagram.png)

### Data Flow

AWS Lambda → S3 → Databricks (Bronze → Silver → Gold) → Iceberg Tables → Snowflake → Analytics Views

---

## ⚙️ Pipeline Orchestration (Databricks Workflows)

The pipeline is orchestrated using Databricks Workflows to manage dependencies between Bronze, Silver, and Gold layers.

The workflow ensures that ingestion, transformation, and metric computation run in a structured and reliable sequence.

**Workflow DAG:**
- Bronze → Silver → Gold

![Workflow](images/databricks/workflows/pipeline_workflow.png)

---

## ⚙️ Tech Stack

* **AWS**: Lambda, S3, IAM
* **Databricks**: Auto Loader, Structured Streaming, Delta Lake, Unity Catalog
* **Storage Format**: Delta Lake with Iceberg (Delta UniForm)
* **Warehouse**: Snowflake (Analytics Layer)
* **Languages**: Python (PySpark), SQL

---

## 📥 Data Ingestion (AWS)

Raw subscription events are generated using AWS Lambda and stored in S3.

![S3 Events](images/aws/s3_raw_events.png)

These events simulate real-world SaaS billing systems with:

* subscription activations
* upgrades/downgrades
* cancellations
* late-arriving events
* duplicate events

---

## 🧪 Data Simulation Strategy

To simulate realistic SaaS subscription behavior, the pipeline uses a controlled event generation approach.

- A configurable `BASE_DATE` is used in AWS Lambda to generate events
- Each run produces:
  - events for the base date
  - late-arriving events from the previous 1–3 days
- This mimics real-world data latency and delayed event ingestion

Additionally, snapshot backfill logic is included in the Gold layer to generate historical time-series data for analytics.

This approach enables:
- realistic time-based trends
- testing of late-arriving data handling
- accurate point-in-time analytics

---

## 🥉 Bronze Layer (Raw Ingestion)

Raw JSON events are ingested into Databricks using Auto Loader.

![Bronze Table](images/databricks/bronze/bronze_table.png)

### Key Features

* Streaming ingestion
* Schema enforcement
* Metadata tracking (`processed_at`, `source_file`)

---

## 🥈 Silver Layer (State Modeling)

The Silver layer reconstructs subscription lifecycle using CDC logic.

![Subscriptions History](images/databricks/silver/subscriptions_history.png)

### Key Features

* Deduplication using `event_id`
* Event ordering using `event_time`
* Subscription state modeling (SCD Type 2 style)
* Handles late-arriving and out-of-order events

---

## 🥇 Gold Layer (Business Metrics)

The Gold layer transforms subscription state data into business-facing metrics, separating activity (events) from state (snapshots) to enable accurate analytics.

### Daily Activity Metrics

![Daily Activity](images/databricks/gold/daily_activity_metrics.png)

Tracks:

* new subscriptions
* cancellations
* plan changes

---

### Subscription KPIs Snapshot

![KPIs Snapshot](images/databricks/gold/subscription_kpis_snapshot.png)

Captures point-in-time metrics:

* MRR (Monthly Recurring Revenue)
* active subscriptions
* cancelled subscriptions
* total subscriptions

---

## 📊 Analytics Layer (Snowflake)

The analytics layer combines event-based activity data with point-in-time snapshots to produce business KPIs and trends.

Delta UniForm tables are exposed as Iceberg tables and queried in Snowflake.

---

### 🟢 Business Dashboard (Primary Output)

![Business Dashboard](images/snowflake/business_dashboard.png)

Combines activity and state data to provide:

* MRR
* churn rate
* net growth
* active subscriptions

---

### 🟢 Churn Analysis

![Churn Analysis](images/snowflake/churn_analysis.png)

Measures percentage of cancellations relative to active subscriptions.

---

### 🟢 ARPU Analysis

![ARPU Analysis](images/snowflake/arpu_analysis.png)

Average revenue per active subscription.

---

### 🟢 Subscription Growth

![Subscription Growth](images/snowflake/subscription_growth.png)

Tracks net growth using new subscriptions and cancellations.

---

### 🟢 MRR Trend

![MRR Trend](images/snowflake/mrr_trend.png)

Shows revenue growth over time.

---

### 🟢 Active Subscriptions Trend

![Active Subs](images/snowflake/active_subs_trend.png)

Tracks growth of active users.

---

### 🟢 MRR Change

![MRR Change](images/snowflake/mrr_change.png)

Shows day-over-day revenue changes.

---

## 🧠 Key Concepts Demonstrated

* Event-driven architecture
* Streaming ingestion (Auto Loader)
* Medallion architecture (Bronze, Silver, Gold)
* CDC / SCD Type 2 modeling
* Data lakehouse design (Delta Lake)
* Iceberg compatibility using Delta UniForm
* Separation of processing (Databricks) and analytics (Snowflake)
* Flow vs State modeling for business metrics

---

## 🎯 Business Metrics Modeled

* Monthly Recurring Revenue (MRR)
* Churn Rate
* ARPU (Average Revenue Per User)
* Subscription Growth
* Net Growth

---

## 🚀 How to Run

1. Deploy AWS Lambda for event generation
2. Configure S3 bucket for raw event storage
3. Set up Databricks with Unity Catalog and external location
4. Run Bronze → Silver → Gold notebooks
5. Expose Gold tables as Iceberg (Delta UniForm)
6. Connect Snowflake and create external Iceberg tables
7. Run Snowflake SQL scripts to create analytics views

---

## 📂 Project Structure

```
subscription-revenue-data-platform/

├── aws/
├── databricks/
├── snowflake/
├── images/
├── architecture/
└── README.md
```

---

## 💡 Summary

This project demonstrates how raw event data from a SaaS system can be transformed into meaningful business insights using a modern cloud data stack.

It highlights the complete journey from data generation to analytics consumption.
