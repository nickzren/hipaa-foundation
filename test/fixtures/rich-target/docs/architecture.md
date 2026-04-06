# Architecture

`rich-target` ingests device-linked health measurements through an API, normalizes them in a worker service, and stores them in encrypted object storage and a metadata database.

Evidence included here:
- service architecture and data flow
- infrastructure-as-code for encrypted storage
- worker code that creates audit events

Evidence intentionally missing:
- formal entity classification
- breach notification procedure
- training records
- executed BAAs
