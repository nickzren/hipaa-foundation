# Architecture

`minimal-target` exposes an HTTPS API for collecting symptom-check submissions and stores encrypted records in a managed database.

Known evidence:
- API requests include patient name, date of birth, and symptom data
- service-level audit logging exists
- deployment details and organizational procedures are not included here

Open questions left intentionally unresolved:
- whether the operator is a covered entity, business associate, or outside HIPAA scope
- whether any BAAs exist
- whether risk analysis or training evidence exists outside this repo
