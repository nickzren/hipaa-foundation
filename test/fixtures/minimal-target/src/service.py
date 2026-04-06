def store_intake_submission(patient_id, payload, audit_log):
    record = {
        "patient_id": patient_id,
        "symptoms": payload["symptoms"],
        "submitted_at": payload["submitted_at"],
    }
    audit_log.append({"event": "submission_stored", "patient_id": patient_id})
    return record
