import json
import os
import uuid
import boto3
import random
from datetime import datetime, timezone, timedelta

s3 = boto3.client("s3")

BUCKET = os.environ["BUCKET_NAME"]
PREFIX = os.environ["RAW_PREFIX"]

SUBSCRIPTIONS = [
    {"subscription_id": "sub_1001", "customer_id": "cust_501", "plan_id": "basic", "amount": 1000},
    {"subscription_id": "sub_1002", "customer_id": "cust_502", "plan_id": "pro", "amount": 2000},
    {"subscription_id": "sub_1003", "customer_id": "cust_503", "plan_id": "basic", "amount": 1000},
    {"subscription_id": "sub_1004", "customer_id": "cust_504", "plan_id": "basic", "amount": 1000},
    {"subscription_id": "sub_1005", "customer_id": "cust_505", "plan_id": "basic", "amount": 1000},
    {"subscription_id": "sub_1006", "customer_id": "cust_506", "plan_id": "pro", "amount": 2000},
    {"subscription_id": "sub_1007", "customer_id": "cust_507", "plan_id": "basic", "amount": 1000},
    {"subscription_id": "sub_1008", "customer_id": "cust_508", "plan_id": "pro", "amount": 2000},
    {"subscription_id": "sub_1009", "customer_id": "cust_509", "plan_id": "basic", "amount": 1000}
]

EVENT_TYPES = [
    "SUBSCRIPTION_CREATED",
    "PLAN_CHANGED",
    "SUBSCRIPTION_CANCELLED",
    "SUBSCRIPTION_REACTIVATED"
]


def generate_event(subscription, late_event=False):
    ingested_at = datetime.now(timezone.utc)

    event_time = (
        ingested_at - timedelta(days=random.randint(1, 3))
        if late_event else ingested_at
    )

    event_type = random.choice(EVENT_TYPES)

    plan_id = subscription["plan_id"]
    amount = subscription["amount"]

    if event_type == "PLAN_CHANGED":
        if random.random() < 0.5:
            plan_id = "pro"
            amount = 2000
        else:
            plan_id = "basic"
            amount = 1000

    return {
        "event_id": f"evt_{uuid.uuid4().hex}",
        "subscription_id": subscription["subscription_id"],
        "customer_id": subscription["customer_id"],
        "event_type": event_type,
        "plan_id": plan_id,
        "amount": amount,
        "currency": "INR",
        "event_time": event_time.isoformat(),
        "ingested_at": ingested_at.isoformat(),
        "source": "billing_lambda"
    }


def lambda_handler(event, context):
    events = []
    total_events = random.randint(5, 10)

    for _ in range(total_events):
        subscription = random.choice(SUBSCRIPTIONS)

        # 25% chance of late event
        is_late = random.random() < 0.25
        evt = generate_event(subscription, late_event=is_late)

        events.append(evt)

        # 15% chance of duplicate
        if random.random() < 0.15:
            events.append(evt)

    written_keys = []

    for evt in events:
        event_date = evt["event_time"][:10]
        key = f"{PREFIX}event_date={event_date}/{evt['event_id']}.json"

        s3.put_object(
            Bucket=BUCKET,
            Key=key,
            Body=json.dumps(evt)
        )

        written_keys.append(key)

    return {
        "status": "success",
        "events_written": len(written_keys),
        "late_events_present": True,
        "duplicates_possible": True
    }
