This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.

# Example Assessment: Cascade Patient Portal

This is a synthetic worked example showing a completed HIPAA draft assessment of a covered entity's ePHI system. The target system is fictional. It assumes the assessment was derived directly from repo evidence, without any target-repo-specific HIPAA metadata file.

---

## Header

| Field | Value |
|-------|-------|
| System name | Cascade Patient Portal (CPP) v2.4 |
| System description | Web-based patient portal allowing patients to view lab results, schedule appointments, and message providers. Stores and transmits ePHI. |
| Assessment date | 2026-04-03 |
| Assessed by | AI draft (hipaa-foundation) |
| Knowledge base version | hipaa-foundation v1 |
| Entity type | covered_entity |
| Covered entity type | provider |
| Hybrid entity status | no |
| PHI types in scope | ephi |
| Applicable rules | security_rule, privacy_rule, breach_notification_rule, enforcement_rule |
| Evidence basis | repo-only |
| Assessment confidence | medium |

## Triage Block

```yaml
entity_type: covered_entity
covered_entity_type: provider
hybrid_entity_status: 'no'
entity_type_confidence: high
phi_types_in_scope:
  - ephi
phi_scope_confidence: high
evidence_basis: repo-only
assessment_confidence: medium
applicable_rules:
  - privacy_rule
  - security_rule
  - breach_notification_rule
  - enforcement_rule
part_162_assessment_mode: not_in_scope_v1
state_law_overlay_status: out_of_scope_v1
in_scope_domains:
  - entity-and-applicability
  - risk-analysis-and-management
  - technical-safeguards
  - administrative-safeguards
  - physical-safeguards
  - individual-rights
  - privacy-uses-and-disclosures
  - organizational-requirements
  - breach-notification
  - policies-procedures-documentation
  - training-and-sanctions
excluded_domains:
  - minimum-necessary
open_decisions:
  - Risk analysis not found in reviewed corpus.
  - Training and sanctions evidence is organizational and not in repo.
  - Privacy notices and authorization forms are outside repo evidence.
```

## Domain Ratings Summary

| Domain | Finding | Basis Type | Severity | Addressable Disposition |
|--------|---------|------------|----------|------------------------|
| entity-and-applicability | Adequate | n/a | - | n/a |
| risk-analysis-and-management | Partial | missing_evidence | Major | n/a |
| technical-safeguards | Partial | mixed | Minor | not_evidenced |
| administrative-safeguards | Partial | mixed | Minor | not_evidenced |
| physical-safeguards | Not assessed | missing_evidence | - | n/a |
| individual-rights | Partial | missing_evidence | Minor | n/a |
| privacy-uses-and-disclosures | Not assessed | missing_evidence | - | n/a |
| organizational-requirements | Partial | missing_evidence | Minor | n/a |
| breach-notification | Partial | missing_evidence | Minor | n/a |
| policies-procedures-documentation | Adequate | n/a | - | n/a |
| training-and-sanctions | Not assessed | missing_evidence | - | n/a |

## Detailed Findings

### risk-analysis-and-management

- finding state: Partial
- basis type: missing_evidence
- severity: Major
- addressable disposition: n/a
- observation: The codebase contains no formal risk analysis document, risk register, or risk management plan. Security controls are implemented in code (TLS, encryption, access controls) but there is no evidence that these controls were selected based on a risk analysis. OCR identifies risk analysis as the foundation of the Security Rule and cites it in most enforcement actions. The required implementation specs -- 164.308(a)(1)(ii)(A) risk analysis and 164.308(a)(1)(ii)(B) risk management -- are both required, not addressable.
- what is still needed: Formal risk analysis covering all ePHI, risk management plan with control selection rationale, periodic review schedule.
- recommendation: Conduct an organization-wide risk analysis per OCR guidance. Document the analysis, risk register, and management plan. Tie security control selection to identified risks. Establish a periodic review cadence.
- evidence reviewed:
  - `infrastructure/` -- security configuration present but no risk basis documented
  - `docs/` -- no risk analysis or risk register found
- external dependency note: Risk analysis is an organizational process. The absence from a code repository is expected but still must be confirmed as a gap through external evidence review. Given that no risk analysis artifact of any kind was found, and this is a required spec, Partial is appropriate even on repo-only evidence.

---

### technical-safeguards

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: not_evidenced
- observation: Strong technical controls are present. Unique user IDs are enforced via OAuth 2.0 with OIDC. TLS 1.2+ is enforced for all connections (164.312(e)(2)(ii) encryption in transit -- addressable, implemented). Audit logging captures user access, data views, and modifications (164.312(b) audit controls -- required, implemented). Session timeout is configured at 15 minutes (164.312(a)(2)(iii) automatic logoff -- addressable, implemented). However, encryption at rest status is not determinable from the repo. The addressable spec 164.312(a)(2)(iv) encryption and decryption has no disposition documented. Integrity controls (164.312(c)(2)) have no documented assessment. No audit log review evidence was found.
- what is still needed: Encryption at rest documentation or configuration evidence. Addressable specification disposition records for 164.312(a)(2)(iv) and 164.312(c)(2). Audit log review schedule and execution records.
- recommendation: Document encryption at rest status with risk analysis basis. For each addressable spec, record the disposition (implemented, alternative, or documented exception). Establish a periodic audit log review process.
- evidence reviewed:
  - `src/auth/oauth.ts` -- OAuth 2.0 / OIDC implementation with unique user IDs
  - `src/middleware/session.ts` -- 15-minute session timeout
  - `infrastructure/tls.tf` -- TLS 1.2+ enforcement
  - `src/logging/audit.ts` -- structured audit logging for all ePHI access events
- external dependency note: Audit log review and addressable spec disposition records are organizational evidence. Encryption at rest may be configured at the infrastructure layer outside the application repo.

---

### training-and-sanctions

- finding state: Not assessed
- basis type: missing_evidence
- severity: -
- addressable disposition: n/a
- observation: The reviewed corpus (repo-only) contains no training records, training materials, sanctions policy, or sanctions enforcement evidence. Security awareness and training (164.308(a)(5)) requires the standard to be implemented; its implementation specs (security reminders, malicious software protection, log-in monitoring, password management) are all addressable. Sanction policy (164.308(a)(1)(ii)(C)) is a required implementation spec under security management. These are organizational controls that typically live outside code repositories.
- what is still needed: Training program documentation, training completion records, sanctions policy, sanctions enforcement evidence (if any).
- recommendation: Confirm whether training and sanctions programs exist outside the codebase. If they do, collect evidence for a follow-up assessment with external evidence. If they do not, establish both programs.
- evidence reviewed:
  - No relevant files found in reviewed corpus.
- external dependency note: Training and sanctions are inherently organizational. Not assessed is the appropriate finding on repo-only evidence per the assessment rubric.

---

### administrative-safeguards

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: not_evidenced
- observation: The codebase shows automated backup scripts running daily with point-in-time recovery configured (data backup plan -- 164.308(a)(7)(ii)(A), required, evidence present). Incident response webhooks and alerting are configured (security incident procedures -- 164.308(a)(6), evidence present). Access provisioning is automated via Terraform IAM (information access management -- 164.308(a)(4), evidence present). However, no designated security official is identified in the repo (164.308(a)(2), required). No workforce clearance or termination procedures were found (164.308(a)(3)(ii)(A-C), addressable, not evidenced). No contingency plan testing evidence was found (164.308(a)(7)(ii)(D), addressable, not evidenced). No evaluation evidence was found (164.308(a)(8), required).
- what is still needed: Security official designation, workforce security procedures, contingency plan testing records, evaluation documentation, addressable spec disposition records.
- recommendation: Document the designated security official. Establish workforce clearance and termination procedures. Test the contingency plan and document results. Conduct a periodic evaluation per 164.308(a)(8). Record addressable spec dispositions.
- evidence reviewed:
  - `infrastructure/backup.tf` -- daily backup configuration with PITR
  - `infrastructure/iam.tf` -- automated access provisioning
  - `src/monitoring/alerts.ts` -- incident detection and alerting
  - `scripts/incident-response.sh` -- incident response playbook automation
- external dependency note: Security official designation, workforce procedures, and evaluation are organizational controls. Contingency plan testing may have been performed but evidence is not in the repo.

---

### individual-rights

- finding state: Partial
- basis type: missing_evidence
- severity: Minor
- addressable disposition: n/a
- observation: The patient portal provides a "View My Records" feature that exports ePHI in PDF and JSON formats (164.524 access of individuals). The system supports an amendment request workflow in the UI (164.526 amendment). However, no accounting of disclosures mechanism was found (164.528). No evidence of privacy notice delivery through the portal (164.520). The access request response timeline and fee structure are not documented in the codebase.
- what is still needed: Accounting of disclosures implementation or documentation. Privacy notice delivery mechanism. Access request response timeline and fee documentation.
- recommendation: Implement or document the accounting of disclosures mechanism. Ensure the portal delivers the notice of privacy practices. Document the response timeline for access requests and confirm it meets the 30-day requirement.
- evidence reviewed:
  - `src/patient/records-export.ts` -- ePHI export in PDF and JSON
  - `src/patient/amendment-request.ts` -- amendment request workflow
- external dependency note: Privacy notices and accounting of disclosures may exist outside the codebase. OCR has made individual right of access a priority enforcement area.

---

### organizational-requirements

- finding state: Partial
- basis type: missing_evidence
- severity: Minor
- addressable disposition: n/a
- observation: The codebase references a third-party lab integration and a cloud hosting provider, both of which would require BAAs (164.314(a), 164.308(b)). No executed BAAs were found in the reviewed corpus. Integration code includes data exchange patterns that suggest the third-party lab receives ePHI. The cloud hosting configuration is managed via Terraform but no BAA reference is included.
- what is still needed: Executed BAAs with the lab integration vendor and cloud hosting provider. BA oversight documentation.
- recommendation: Confirm BAAs are in place for all business associates. Include BAA references in vendor management documentation. Verify that BA obligations are monitored.
- evidence reviewed:
  - `src/integrations/lab-api.ts` -- ePHI transmission to third-party lab
  - `infrastructure/main.tf` -- cloud hosting configuration
- external dependency note: Executed BAAs are legal documents that would not normally be in a code repository. Confirm their existence through external evidence review.

---

### breach-notification

- finding state: Partial
- basis type: missing_evidence
- severity: Minor
- addressable disposition: n/a
- observation: The incident response automation (alerting, webhook notifications) provides a technical foundation for breach detection. However, no formal breach notification procedure was found. No risk assessment framework for determining whether a breach is reportable under 164.402 was identified. No notification templates or timelines were documented. Encryption in transit (TLS) may provide safe harbor for data in transit, but encryption at rest status is undetermined -- so the safe harbor cannot be fully assessed.
- what is still needed: Breach notification procedure, risk assessment framework for breach determination, notification templates, timeline documentation, encryption at rest confirmation for safe harbor assessment.
- recommendation: Establish a breach notification procedure covering the 164.402 risk assessment, individual notification (164.404), media notification (164.406 if applicable), Secretary notification (164.408), and BA notification obligations (164.410). Confirm encryption at rest for safe harbor assessment.
- evidence reviewed:
  - `src/monitoring/alerts.ts` -- breach detection foundation
  - `infrastructure/tls.tf` -- encryption in transit for safe harbor
- external dependency note: Breach notification procedures and risk assessment frameworks are organizational controls. Safe harbor assessment requires confirmation of encryption at rest.

## Phased Remediation

**Phase 1 -- Entity and scope confirmation**
- Confirm entity type and applicability (currently rated Adequate based on clear provider status).
- Confirm PHI scope and system boundaries.

**Phase 2 -- Risk analysis and addressable-spec disposition**
- Conduct organization-wide risk analysis per OCR guidance.
- Document risk management plan with control selection rationale.
- Record addressable specification dispositions for all Security Rule addressable specs.
- Priority: risk analysis is the most common OCR enforcement finding.

**Phase 3 -- Technical control completion**
- Confirm and document encryption at rest status.
- Implement or document integrity controls (164.312(c)(2)).
- Establish audit log review process.
- Implement accounting of disclosures mechanism.

**Phase 4 -- Organizational evidence completion**
- Designate security official (164.308(a)(2)).
- Establish workforce security procedures.
- Collect or establish training and sanctions programs.
- Confirm BAAs are in place for all business associates.
- Establish breach notification procedure.
- Conduct contingency plan testing.
- Conduct periodic evaluation (164.308(a)(8)).

## Self-Review Confirmation

The following self-review checks from `core/checklists/assessment-self-review.md` were completed:

- [x] Content policy checked.
- [x] Entity type determined before setting assessment depth.
- [x] Structured triage block produced before domain findings.
- [x] For every addressable Security Rule spec, addressable disposition was captured.
- [x] `missing_evidence` kept separate from `observed_gap` throughout.
- [x] Repo-only realism rule applied for organizational controls (training, sanctions, BAAs, privacy notices rated Not assessed or Partial, not Gap).
- [x] Addressable specs not treated as gaps when disposition is undocumented in a repo-only review.
- [x] Output begins AND ends with the exact disclaimer.

This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.
