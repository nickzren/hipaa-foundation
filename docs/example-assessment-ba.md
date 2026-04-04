This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.

# Example Assessment: Meridian Analytics Platform (Business Associate)

This is a synthetic worked example showing a completed HIPAA draft assessment of a business associate's ePHI system. The target system is fictional. Meridian Analytics is a SaaS analytics company that processes claims data on behalf of health plan clients.

---

## Header

| Field | Value |
|-------|-------|
| System name | Meridian Analytics Platform (MAP) v5.1 |
| System description | Cloud-hosted analytics platform that ingests, processes, and reports on health plan claims data. Receives ePHI from covered entity clients via SFTP and API. |
| Assessment date | 2026-04-03 |
| Assessed by | AI draft (hipaa-foundation) |
| Knowledge base version | hipaa-foundation v1 |
| Entity type | business_associate |
| Covered entity type | not_applicable |
| Hybrid entity status | no |
| PHI types in scope | ephi |
| Applicable rules | security_rule, breach_notification_rule, enforcement_rule |
| Evidence basis | repo-plus-external-evidence |
| Assessment confidence | medium |

## Triage Block

```yaml
entity_type: business_associate
covered_entity_type: not_applicable
hybrid_entity_status: 'no'
entity_type_confidence: high
phi_types_in_scope:
  - ephi
phi_scope_confidence: high
evidence_basis: repo-plus-external-evidence
assessment_confidence: medium
applicable_rules:
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
  - organizational-requirements
  - breach-notification
  - policies-procedures-documentation
  - training-and-sanctions
excluded_domains:
  - privacy-uses-and-disclosures
  - minimum-necessary
  - individual-rights
open_decisions:
  - BAA template reviewed but executed BAAs with specific CEs were not provided.
  - Subcontractor BAA status for cloud infrastructure provider not confirmed.
  - Risk analysis last revision date not verified.
```

**Note on BA Privacy Rule scope:** Business associates are directly liable only for specified HIPAA provisions, not the full covered-entity Privacy Rule domain set. This example excludes the full Privacy domains -- uses and disclosures, minimum necessary, and individual rights -- because they are primarily covered-entity obligations unless delegated functions or specific BA privacy duties are actually in scope. BA-specific privacy obligations evidenced through the BAA or direct-liability provisions are captured under organizational-requirements.

## Domain Ratings Summary

| Domain | Finding | Basis Type | Severity | Addressable Disposition |
|--------|---------|------------|----------|------------------------|
| entity-and-applicability | Adequate | n/a | - | n/a |
| risk-analysis-and-management | Partial | mixed | Minor | n/a |
| technical-safeguards | Adequate | n/a | - | implemented |
| administrative-safeguards | Partial | mixed | Minor | alternative |
| physical-safeguards | Partial | missing_evidence | Minor | not_evidenced |
| organizational-requirements | Partial | mixed | Minor | n/a |
| breach-notification | Partial | mixed | Minor | n/a |
| policies-procedures-documentation | Adequate | n/a | - | n/a |
| training-and-sanctions | Partial | missing_evidence | Observation | n/a |

## Detailed Findings

### risk-analysis-and-management

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: n/a
- observation: A risk analysis document was provided as external evidence (dated 2024-08). It covers the analytics platform and identifies key threats to ePHI. A risk register with 23 items is maintained. Risk management controls are mapped to identified risks. However, the risk analysis predates a significant infrastructure migration (completed 2025-03 per commit history). The risk analysis does not reflect the current cloud environment. OCR guidance requires the risk analysis to be updated when the environment changes. Risk analysis (164.308(a)(1)(ii)(A)) and risk management (164.308(a)(1)(ii)(B)) are both required specs.
- what is still needed: Updated risk analysis reflecting the current infrastructure. Updated risk register entries for new environment. Evidence of periodic review cadence.
- recommendation: Update the risk analysis to cover the current cloud environment. Establish and document a periodic review schedule triggered by environment changes and at least annually.
- evidence reviewed:
  - External: `risk-analysis-2024-08.pdf` -- risk analysis document (pre-migration)
  - External: `risk-register.xlsx` -- 23-item risk register
  - `infrastructure/` -- migration commits from 2025-03 showing new cloud environment
- external dependency note: The risk analysis exists but is stale. This is rated Partial rather than Not assessed because external evidence was reviewed and a specific gap was identified.

---

### administrative-safeguards

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: alternative
- observation: A designated security official is identified in the external policy documents (164.308(a)(2), required, implemented). Automated data backup runs hourly with cross-region replication (164.308(a)(7)(ii)(A), required, implemented). Disaster recovery runbooks exist in the repo (164.308(a)(7)(ii)(B), required, implemented). Emergency mode operation is documented with degraded-service procedures (164.308(a)(7)(ii)(C), required, implemented). However, workforce clearance procedures (164.308(a)(3)(ii)(B), addressable) are implemented via an alternative measure: automated background check integration during onboarding rather than a manual clearance procedure. This is documented in the HR integration README. Termination procedures (164.308(a)(3)(ii)(C), addressable) are automated via identity provider deprovisioning but the procedure document references the old identity provider. Contingency plan testing (164.308(a)(7)(ii)(D), addressable) was last performed 18 months ago per external evidence. Applications and data criticality analysis (164.308(a)(7)(ii)(E), addressable) is not documented.
- what is still needed: Updated termination procedure referencing current identity provider. Recent contingency plan test results. Applications and data criticality analysis or documented exception.
- recommendation: Update the termination procedure to reference the current identity provider. Conduct contingency plan testing and document results. Perform applications and data criticality analysis or document why it is not reasonable and appropriate with risk analysis basis.
- evidence reviewed:
  - External: `security-officer-designation.pdf` -- security official identified
  - `infrastructure/backup.tf` -- hourly backup with cross-region replication
  - `docs/disaster-recovery-runbook.md` -- disaster recovery procedures
  - `docs/emergency-mode.md` -- degraded-service procedures
  - `integrations/hr-onboarding/README.md` -- alternative workforce clearance via automated background checks
  - `infrastructure/identity/` -- identity provider deprovisioning automation
  - External: `contingency-test-2024-09.pdf` -- last contingency plan test (18 months old)
- external dependency note: Workforce clearance alternative measure is documented and qualifies as a valid addressable disposition. Contingency test staleness and missing criticality analysis are specific gaps.

---

### physical-safeguards

- finding state: Partial
- basis type: missing_evidence
- severity: Minor
- addressable disposition: not_evidenced
- observation: The system runs entirely in a cloud environment. Physical facility access controls (164.310(a)(1)) are delegated to the cloud provider. Workstation use (164.310(b)) and workstation security (164.310(c)) policies were not found in the reviewed corpus or external evidence. Device and media controls (164.310(d)(1)) are partially addressed: disposal (164.310(d)(2)(i), required) is implemented via cloud provider's media destruction certification. Media re-use (164.310(d)(2)(ii), required) is addressed by the cloud provider's shared responsibility model. However, accountability for hardware and media (164.310(d)(2)(iii), addressable) tracking is not documented. Data backup and storage (164.310(d)(2)(iv), addressable) is addressed by the backup infrastructure but no disposition is recorded.
- what is still needed: Workstation use and security policies (even for remote/cloud-only workforce). Physical safeguards delegation documentation (cloud shared responsibility model). Addressable spec dispositions for 164.310(d)(2)(iii) and 164.310(d)(2)(iv). Facility access controls documentation or cloud provider delegation documentation.
- recommendation: Document the cloud shared responsibility model for physical safeguards. Establish workstation use and security policies for the workforce. Record addressable spec dispositions with risk analysis basis.
- evidence reviewed:
  - `infrastructure/main.tf` -- cloud-only deployment
  - External: `cloud-provider-media-destruction-cert.pdf` -- disposal certification
- external dependency note: Physical safeguards in cloud environments are often delegated. The delegation itself is valid but must be documented.

---

### organizational-requirements

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: n/a
- observation: A BAA template was provided as external evidence. The template includes required provisions per 164.314(a)(2)(i): permitted and required uses of PHI, safeguard requirements, reporting obligations, and termination provisions. However, executed BAAs with specific CE clients were not provided -- only the template. As a BA, Meridian uses a cloud infrastructure provider that receives ePHI (subcontractor relationship per 164.502(e)(1)(ii)). No subcontractor BAA was provided or referenced. The BAA template does not address subcontractor flow-down. BA-specific Privacy Rule obligations (limiting uses and disclosures to BAA terms per 164.502(a)) are implemented via role-based access controls that restrict data access to contracted purposes, but no formal use-and-disclosure policy was found.
- what is still needed: Executed BAAs with CE clients (or confirmation they exist). Subcontractor BAA with cloud infrastructure provider. BA use-and-disclosure policy. BAA template update to include subcontractor flow-down provisions.
- recommendation: Confirm executed BAAs are in place for all CE relationships. Execute a subcontractor BAA with the cloud infrastructure provider. Update the BAA template to include subcontractor flow-down. Establish a formal BA use-and-disclosure policy that maps to BAA terms.
- evidence reviewed:
  - External: `baa-template-v3.docx` -- BAA template with required provisions
  - `src/auth/rbac.ts` -- role-based access controls restricting data access
  - `infrastructure/main.tf` -- cloud infrastructure provider configuration
- external dependency note: Executed BAAs are legal documents. The template is reviewed but execution evidence requires confirmation. Subcontractor BAA is a post-HITECH requirement that OCR enforces.

---

### breach-notification

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: n/a
- observation: The system implements encryption in transit (TLS 1.3) and at rest (AES-256), which provides the encryption safe harbor per HHS guidance (unsecured PHI triggers notification; secured PHI does not). A breach notification procedure exists as external evidence. The procedure includes the 164.402 risk assessment framework with the four-factor test. However, the procedure specifies BA notification obligations to the CE (164.410) with a 30-day timeline, but the BAA template specifies "without unreasonable delay." The procedure and BAA template are inconsistent on the notification timeline. No breach investigation log or tabletop exercise evidence was found.
- what is still needed: Reconciliation of procedure and BAA template notification timelines. Breach investigation log template. Tabletop exercise or drill evidence.
- recommendation: Align the breach notification procedure with BAA terms on notification timeline. Implement a breach investigation log. Conduct a tabletop exercise to validate the procedure.
- evidence reviewed:
  - `infrastructure/encryption.tf` -- AES-256 at rest, TLS 1.3 in transit
  - External: `breach-notification-procedure-v2.pdf` -- notification procedure with risk assessment
  - External: `baa-template-v3.docx` -- BAA template notification terms
- external dependency note: The encryption safe harbor is well-established. The inconsistency between procedure and BAA is a governance gap, not a technical one. Breach drill evidence is organizational.

---

### training-and-sanctions

- finding state: Partial
- basis type: missing_evidence
- severity: Observation
- addressable disposition: n/a
- observation: An external training policy document references annual HIPAA security awareness training for all workforce members with ePHI access. The policy also references role-based training for developers handling ePHI. However, no training completion records or training materials were provided. The security reminders implementation spec (164.308(a)(5)(ii)(A), addressable) is described in the policy as quarterly email reminders, but no evidence of delivery was provided. A sanctions policy is referenced in the employee handbook excerpt provided but no sanctions enforcement evidence was found. Sanction policy (164.308(a)(1)(ii)(C)) is a required spec -- the policy exists but execution evidence is missing.
- what is still needed: Training completion records. Training materials. Security reminder delivery evidence. Sanctions enforcement records (if any sanctions have been applied).
- recommendation: Collect training completion records to demonstrate program execution. Retain security reminder delivery evidence. The existing policy documents establish the program -- execution evidence is the gap.
- evidence reviewed:
  - External: `training-policy-2025.pdf` -- training program policy
  - External: `employee-handbook-excerpt.pdf` -- sanctions policy reference
- external dependency note: Training and sanctions are inherently organizational. The policies exist (unlike a repo-only review where they would typically be Not assessed). The gap is execution evidence, not program existence, which is why Partial is appropriate rather than Not assessed.

## Phased Remediation

**Phase 1 -- Entity and scope confirmation**
- Entity type (business_associate) and scope are established. No remediation needed.
- Confirm subcontractor relationships and BA chain.

**Phase 2 -- Risk analysis and addressable-spec disposition**
- Update the risk analysis to reflect the current cloud environment.
- Record addressable specification dispositions for all Security Rule addressable specs.
- Complete applications and data criticality analysis (164.308(a)(7)(ii)(E)).
- Priority: stale risk analysis is a common OCR enforcement finding.

**Phase 3 -- Organizational and contractual completion**
- Execute or confirm executed BAAs with all CE clients.
- Execute subcontractor BAA with cloud infrastructure provider.
- Update BAA template to include subcontractor flow-down provisions.
- Reconcile breach notification procedure with BAA notification timeline.
- Establish BA use-and-disclosure policy.

**Phase 4 -- Operational evidence completion**
- Update termination procedure to reference current identity provider.
- Conduct contingency plan testing and document results.
- Collect training completion records.
- Document physical safeguards delegation (cloud shared responsibility model).
- Establish workstation use and security policies.
- Conduct breach notification tabletop exercise.

## Self-Review Confirmation

The following self-review checks from `core/checklists/assessment-self-review.md` were completed:

- [x] Content policy checked.
- [x] Entity type determined before setting assessment depth. BA entity type drives domain selection: full Privacy Rule domains excluded, BA-specific obligations captured under organizational-requirements.
- [x] Structured triage block produced before domain findings.
- [x] For every addressable Security Rule spec, addressable disposition was captured.
- [x] `missing_evidence` kept separate from `observed_gap` throughout. Stale risk analysis is an observed gap; missing training records are missing evidence.
- [x] Repo-only realism rule applied where applicable. With external evidence available, some domains that would be Not assessed on repo-only are rated Partial with specific gaps identified.
- [x] Addressable specs not treated as gaps. Workforce clearance alternative measure (automated background checks) is recognized as a valid addressable disposition.
- [x] Output begins AND ends with the exact disclaimer.

This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.
