# Data Flow

1. Client devices submit identifiable health measurements over HTTPS.
2. API workers validate the payload and enqueue it for normalization.
3. The normalization worker writes normalized measurements to object storage.
4. Metadata and audit events are written to the application database.

Potential HIPAA-relevant signals:
- identifiable health data is processed and stored
- audit events exist
- encryption at rest is configured in infrastructure
- organizational evidence is not bundled here
