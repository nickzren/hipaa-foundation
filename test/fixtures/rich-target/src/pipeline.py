def normalize_measurement(payload, audit_sink):
    normalized = {
        "subject_id": payload["subject_id"],
        "metric": payload["metric"],
        "value": payload["value"],
        "captured_at": payload["captured_at"],
    }
    audit_sink.write({"event": "measurement_normalized", "subject_id": payload["subject_id"]})
    return normalized
