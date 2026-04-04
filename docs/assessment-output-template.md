This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.

# Assessment Output Template

Every assessment output must begin AND end with the exact disclaimer text above. This is a hard requirement -- do not omit either instance.

Exact disclaimer text:

This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.

The opening disclaimer must be the very first content in the output file, before the header or title. The closing disclaimer must be the very last content.

## Header

| Field | Value |
|-------|-------|
| System name | |
| System description | |
| Assessment date | |
| Assessed by | |
| Knowledge base version | hipaa-foundation v1 |
| Entity type | covered_entity / business_associate / ba_subcontractor / not_regulated / tbd |
| Covered entity type | provider / health_plan / clearinghouse / not_applicable / tbd |
| Hybrid entity status | yes / no / tbd |
| PHI types in scope | |
| Applicable rules | |
| Evidence basis | repo-only / repo-plus-external-evidence / repo-plus-runtime-or-interviews |
| Assessment confidence | low / medium / high |

## Triage Block

Produce a YAML triage block conforming to `core/applicability/triage-output-template.yaml`. Include it here before any findings.

```yaml
entity_type:
covered_entity_type:
hybrid_entity_status:
entity_type_confidence:
phi_types_in_scope: []
phi_scope_confidence:
evidence_basis:
assessment_confidence:
applicable_rules: []
part_162_assessment_mode:
state_law_overlay_status:
in_scope_domains: []
excluded_domains: []
open_decisions: []
```

If `entity_type` is `tbd`, include a short scope note after the triage block explaining:
- why Privacy-specific domains are excluded
- what evidence would bring them into scope (e.g., confirmed entity type from governance documentation)

## Domain Ratings Summary

Use a table with an `addressable_disposition` column for Security Rule specs:

```text
| Domain | Finding | Basis Type | Severity | Addressable Disposition |
|--------|---------|------------|----------|------------------------|
| entity-and-applicability | Partial | missing_evidence | Minor | n/a |
| risk-analysis-and-management | Not assessed | missing_evidence | - | n/a |
| technical-safeguards | Partial | mixed | Minor | not_evidenced |
| training-and-sanctions | Not assessed | missing_evidence | - | n/a |
```

Addressable disposition values: implemented, alternative, documented_exception, not_evidenced, n/a (for non-addressable or non-Security-Rule domains).

## Detailed Findings

Include one detailed section for every domain row that is not `Adequate` or `Not applicable`.

Each detailed section should include:
- domain
- finding state
- basis type (missing_evidence, observed_gap, or mixed)
- severity
- addressable disposition (for Security Rule addressable specs)
- observation
- what is still needed
- recommendation
- evidence reviewed
- external dependency note

Example:

```md
### technical-safeguards

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: not_evidenced
- observation: TLS encryption in transit is implemented. Encryption at rest status is not determinable from the repo. Audit logging is present but review evidence is external.
- what is still needed: Encryption at rest documentation or implementation, audit log review records, addressable spec disposition documentation.
- recommendation: Document encryption at rest disposition with risk analysis basis. Establish audit log review schedule.
- evidence reviewed:
  - `infrastructure/tls.tf`
  - `src/logging/audit.py`
- external dependency note: Encryption at rest disposition and audit log review require organizational evidence.
```

## Phased Remediation

Group remediation into short phases:
- entity and scope confirmation
- risk analysis and addressable-spec disposition
- technical control completion
- organizational evidence completion

## Self-Review Confirmation

State that the self-review checklist (`core/checklists/assessment-self-review.md`) was run.

This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.
