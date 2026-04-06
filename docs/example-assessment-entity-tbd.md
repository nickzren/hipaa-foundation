This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.

# Example Assessment: Meridian Health Data Pipeline (Entity Type TBD)

This is a synthetic worked example showing a completed HIPAA draft assessment when entity type cannot be determined from the reviewed corpus. The target system is fictional. Meridian Health Data Pipeline is a serverless AWS pipeline that collects health data from wearable devices (heart rate, SpO2, sleep, activity) and stores it alongside user-provided demographic identifiers. It assumes the assessment was derived directly from repo evidence, without any target-repo-specific HIPAA metadata file.

**Teaching purpose:** This example demonstrates how an assessment correctly handles `entity_type: tbd`. Privacy-specific domains are excluded per domain_selection_rules, the entity classification is not overclaimed, strong technical findings are still captured, and organizational gaps are noted as evidence limitations rather than control gaps.

---

## Header

| Field | Value |
|-------|-------|
| System name | Meridian Health Data Pipeline v1.2 |
| System description | Serverless AWS pipeline collecting identifiable health data from wearable devices (heart rate, SpO2, sleep, activity). Ingests via API Gateway, processes through Lambda, stores in S3 with DynamoDB metadata. User-provided demographic identifiers are stored alongside health metrics. |
| Assessment date | 2026-04-03 |
| Assessed by | AI draft (hipaa-foundation) |
| Knowledge base version | hipaa-foundation v1 |
| Entity type | tbd |
| Covered entity type | tbd |
| Hybrid entity status | tbd |
| PHI types in scope | ephi |
| Applicable rules | security_rule, breach_notification_rule, enforcement_rule |
| Evidence basis | repo-only |
| Assessment confidence | low |

## Triage Block

```yaml
entity_type: tbd
covered_entity_type: tbd
hybrid_entity_status: tbd
entity_type_confidence: low
phi_types_in_scope:
  - ephi
phi_scope_confidence: medium
evidence_basis: repo-only
assessment_confidence: low
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
  - Entity type not determinable from reviewed corpus. No formal entity classification, BAA, or regulatory filing found. System handles identifiable health data from wearables but the entity's relationship to the HIPAA ecosystem is unconfirmed.
  - Applicable rules listed conservatively. privacy_rule is omitted because entity type is tbd and Privacy Rule applicability depends on confirmed entity status. If entity type is later confirmed as covered_entity or business_associate handling PHI, privacy_rule should be added and the three excluded Privacy domains re-evaluated.
  - Organizational evidence (risk analysis, security official, training records) not found in repo. These may exist outside the codebase.
  - BAA with the wearable device vendor (third-party wearable) not found.
```

**Note on entity_type: tbd scope:** Entity type could not be determined from the repository. The system clearly handles identifiable health data (ePHI), so Security Rule and Breach Notification Rule obligations are assessed as a conservative review posture pending entity confirmation. However, per domain_selection_rules, when entity_type is tbd, only `by_applicable_rule` and `always_in_scope` domains enter scope. The three Privacy-specific domains -- privacy-uses-and-disclosures, minimum-necessary, and individual-rights -- require a confirmed entity type and are excluded. This is not a finding about those domains, and it is not a legal determination of HIPAA applicability; it is a scope boundary for a conservative draft assessment. If entity type is later confirmed, those domains must be re-evaluated.

## Domain Ratings Summary

| Domain | Finding | Basis Type | Severity | Addressable Disposition |
|--------|---------|------------|----------|------------------------|
| entity-and-applicability | Partial | missing_evidence | Minor | n/a |
| risk-analysis-and-management | Not assessed | missing_evidence | - | n/a |
| technical-safeguards | Partial | mixed | Minor | not_evidenced |
| administrative-safeguards | Partial | mixed | Minor | not_evidenced |
| physical-safeguards | Not assessed | missing_evidence | - | n/a |
| organizational-requirements | Partial | mixed | Minor | n/a |
| breach-notification | Partial | mixed | Minor | n/a |
| policies-procedures-documentation | Partial | missing_evidence | Minor | n/a |
| training-and-sanctions | Not assessed | missing_evidence | - | n/a |

## Detailed Findings

### entity-and-applicability

- finding state: Partial
- basis type: missing_evidence
- severity: Minor
- addressable disposition: n/a
- observation: The system clearly handles ePHI. Health metrics (heart rate, SpO2, sleep stages, activity) are stored alongside user-provided demographic identifiers (name, date of birth, email) in DynamoDB. This combination constitutes individually identifiable health information under 45 CFR 160.103. However, the entity's role in the HIPAA ecosystem is not documented in the repo. There is no entity classification document, no BAA, no provider enrollment evidence, no health plan relationship, and no clearinghouse function. The system could be a covered entity collecting patient data, a business associate processing data on behalf of a CE, or a consumer wellness platform outside HIPAA scope. Without entity classification, downstream obligations cannot be fully determined. The assessment proceeds conservatively for review purposes: the presence of ePHI brings Security Rule and Breach Notification Rule domains into scope, while entity-gated Privacy domains remain excluded pending confirmation. That is an assessment posture, not a legal conclusion that HIPAA definitely applies.
- what is still needed: Formal entity type determination. Documentation of the entity's relationship to the HIPAA ecosystem (CE, BA, BA subcontractor, or not regulated). If BA, an executed BAA establishing the relationship. If CE, the covered entity type (provider, health plan, clearinghouse).
- recommendation: Conduct a formal entity classification review. Document the result and the basis for the determination. This is the single highest-priority remediation item because it gates the entire scope of the assessment -- three Privacy domains, applicable rules, and obligation depth all depend on confirmed entity type.
- evidence reviewed:
  - `infrastructure/dynamodb.tf` -- table schema with user demographic fields and health metric fields
  - `src/ingest/api-handler.py` -- Lambda handler receiving wearable data with user identifiers
  - `docs/` -- no entity classification, BAA, or regulatory relationship documentation found
- external dependency note: Entity classification is an organizational and legal determination. Its absence from a code repository is not unusual, but it must be resolved before this assessment can be considered complete.

---

### risk-analysis-and-management

- finding state: Not assessed
- basis type: missing_evidence
- severity: -
- addressable disposition: n/a
- observation: The reviewed corpus contains no risk analysis document, risk register, risk management plan, or risk analysis methodology. The Security Rule requires a risk analysis (164.308(a)(1)(ii)(A), required) and risk management plan (164.308(a)(1)(ii)(B), required) as the foundation for all other safeguard decisions. Strong technical controls exist in the codebase (KMS encryption, IAM deny policies, VPC isolation), but there is no evidence these were selected based on a risk analysis. No periodic review schedule or risk acceptance criteria were found.
- what is still needed: Formal risk analysis covering all ePHI in the system. Risk management plan with control selection rationale. Risk register. Periodic review schedule.
- recommendation: Conduct a risk analysis per OCR guidance covering the Meridian pipeline's ePHI assets, threats, vulnerabilities, and controls. Document why the existing technical controls (KMS, Object Lock, VPC isolation) were selected. Establish a periodic review cadence. Risk analysis is the most common finding in OCR enforcement actions and is the foundation of the Security Rule.
- evidence reviewed:
  - `infrastructure/` -- strong security configuration present but no risk basis documented
  - `docs/` -- no risk analysis, risk register, or risk management artifacts found
- external dependency note: Risk analysis is an organizational process. Its absence from a code repository is expected. Not assessed is the appropriate finding on repo-only evidence per the assessment rubric, because no partial evidence of any kind was found.

---

### technical-safeguards

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: not_evidenced
- observation: The system implements strong technical safeguards. Encryption at rest is configured via AWS KMS with customer-managed keys for S3 and DynamoDB (164.312(a)(2)(iv) encryption and decryption -- addressable, implemented). S3 Object Lock provides WORM-style integrity protection for ingested health data (164.312(c)(1) integrity -- required, implemented). TLS 1.2+ is enforced on API Gateway endpoints (164.312(e)(2)(ii) encryption in transit -- addressable, implemented). IAM deny policies enforce least-privilege access to ePHI buckets and tables. CloudTrail logging captures all API calls to ePHI resources (164.312(b) audit controls -- required, implemented). Lambda execution roles are scoped to specific resources with no wildcard permissions.

However, several addressable spec dispositions are not formally documented. Automatic logoff (164.312(a)(2)(iii)) is not applicable to a serverless pipeline with no interactive sessions, but this disposition is not recorded. Authentication to the ingest API uses API keys rather than unique user identification (164.312(d) person or entity authentication -- required). The API key model does not distinguish individual users or devices. No audit log review process or schedule was found. No integrity mechanism validation evidence was found (164.312(c)(2) mechanism to authenticate ePHI -- addressable, not evidenced).

- what is still needed: Addressable specification disposition records for all Security Rule addressable specs. Person or entity authentication mechanism that distinguishes individual data sources. Audit log review schedule and execution records. Integrity mechanism validation evidence or documented disposition for 164.312(c)(2).
- recommendation: Document addressable spec dispositions with risk analysis basis. Replace or supplement API key authentication with a mechanism that provides person or entity identification (e.g., per-device tokens, OAuth client credentials). Establish a CloudTrail log review schedule. For automatic logoff, document the "not applicable to serverless pipeline" determination as the addressable disposition.
- evidence reviewed:
  - `infrastructure/kms.tf` -- customer-managed KMS keys for S3 and DynamoDB encryption
  - `infrastructure/s3.tf` -- S3 Object Lock (WORM) configuration, bucket policy with deny rules
  - `infrastructure/api-gateway.tf` -- TLS 1.2+ enforcement, API key authentication
  - `infrastructure/iam.tf` -- IAM deny policies, scoped Lambda execution roles
  - `infrastructure/cloudtrail.tf` -- CloudTrail logging for all ePHI resource API calls
  - `src/ingest/api-handler.py` -- Lambda handler with no interactive session context
- external dependency note: Audit log review and addressable spec disposition records are organizational evidence. The technical controls are strong; the gap is documentation of the security rationale and addressable spec dispositions.

---

### administrative-safeguards

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: not_evidenced
- observation: The codebase implements several administrative safeguard controls at the technical layer. IAM deny policies and resource-level permissions enforce information access management (164.308(a)(4), evidence present). S3 versioning with Object Lock and cross-region replication provides a data backup plan (164.308(a)(7)(ii)(A), required, evidence present). CloudWatch alarms are configured for failed API calls, unauthorized access attempts, and CloudTrail log delivery failures -- these provide a foundation for security incident detection (164.308(a)(6), evidence present). SNS topics route alarm notifications, suggesting an alerting workflow exists.

However, no designated security official is identified in the repo (164.308(a)(2), required). No workforce clearance or termination procedures were found (164.308(a)(3)(ii)(A-C), addressable, not evidenced). No contingency plan testing evidence was found (164.308(a)(7)(ii)(D), addressable, not evidenced). No emergency mode operation procedure was found (164.308(a)(7)(ii)(C), required). No formal incident response procedure was found -- CloudWatch alarms detect events but no documented response workflow exists. No evaluation evidence was found (164.308(a)(8), required).

- what is still needed: Designated security official. Workforce security procedures. Incident response procedure (beyond automated detection). Emergency mode operation plan. Contingency plan testing records. Periodic evaluation documentation. Addressable spec disposition records.
- recommendation: Designate a security official responsible for HIPAA security (164.308(a)(2)). Build an incident response procedure that defines roles, escalation paths, and response steps triggered by the existing CloudWatch alarms. Document emergency mode operation for the pipeline. Test the contingency plan (backup/restore, failover) and document results. Conduct a periodic evaluation.
- evidence reviewed:
  - `infrastructure/iam.tf` -- IAM deny policies, resource-level access controls
  - `infrastructure/s3.tf` -- S3 versioning, Object Lock, cross-region replication
  - `infrastructure/cloudwatch.tf` -- alarms for failed API calls, unauthorized access, CloudTrail failures
  - `infrastructure/sns.tf` -- alarm notification routing
- external dependency note: Security official designation, workforce procedures, incident response procedures, and evaluation are organizational controls. Their absence from a code repository is expected. The strong technical detection layer (CloudWatch alarms) provides a foundation for organizational incident response but does not substitute for it.

---

### physical-safeguards

- finding state: Not assessed
- basis type: missing_evidence
- severity: -
- addressable disposition: n/a
- observation: The system is entirely serverless on AWS (Lambda, S3, DynamoDB, API Gateway). Physical facility access controls (164.310(a)(1)) are delegated to AWS. AWS publishes SOC 2 and ISO 27001 reports covering physical security of their data centers. However, no documentation of this delegation was found in the repo. No workstation use (164.310(b)) or workstation security (164.310(c)) policies were found -- these apply to the entity's workforce accessing the pipeline, not to the cloud infrastructure. No device and media controls (164.310(d)(1)) documentation was found. For a serverless system, physical safeguards are primarily about the entity's own endpoint security and the cloud provider delegation, neither of which is evidenced in the repo.
- what is still needed: Cloud shared responsibility model documentation for physical safeguards. Workstation use and security policies for personnel accessing the pipeline. Device and media controls documentation or documented disposition. AWS SOC 2 / ISO 27001 report retention as delegation evidence.
- recommendation: Document the cloud shared responsibility model for physical safeguards, referencing AWS compliance certifications. Establish workstation use and security policies for any personnel with administrative access to the pipeline. Not assessed is appropriate on repo-only evidence because physical safeguards are inherently organizational and facility-based.
- evidence reviewed:
  - `infrastructure/main.tf` -- serverless AWS deployment (Lambda, S3, DynamoDB, API Gateway)
  - No physical safeguards documentation found in reviewed corpus.
- external dependency note: Physical safeguards in serverless cloud environments are almost entirely delegated and organizational. The absence of this evidence from a code repository is expected.

---

### organizational-requirements

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: n/a
- observation: The repository contains a screenshot artifact (`docs/baa-screenshots/aws-baa-acceptance.png`) showing acceptance of the AWS BAA through the AWS Artifact console. This provides evidence that the AWS BAA is in place, which is required if the pipeline stores ePHI on AWS infrastructure (164.308(b), 164.314(a)). However, the wearable device data source (the third-party wearable vendor) transmits identifiable health data to the pipeline via API. If the entity is a CE and the wearable vendor is a BA, or if the entity is a BA and the wearable vendor is a subcontractor, a BAA is required for that relationship. No BAA with the wearable vendor was found. No subcontractor management documentation was found. No BA oversight procedures were found.

The entity type ambiguity compounds this finding: without knowing whether the entity is a CE, BA, or BA subcontractor, the full organizational requirements cannot be determined. The AWS BAA screenshot is a positive artifact but does not resolve the broader organizational-requirements picture.

- what is still needed: Confirmation that the wearable vendor relationship is covered by a BAA (or determination that no BAA is required based on entity classification). Subcontractor management documentation if applicable. BA oversight procedures if the entity has BA relationships.
- recommendation: After entity type is confirmed, map all vendor relationships that involve ePHI and confirm BAAs are in place for each. The AWS BAA is in place -- extend this practice to the wearable vendor relationship. Document BA or subcontractor oversight procedures.
- evidence reviewed:
  - `docs/baa-screenshots/aws-baa-acceptance.png` -- AWS BAA acceptance screenshot
  - `src/ingest/api-handler.py` -- API endpoint receiving data from wearable vendor
  - `infrastructure/api-gateway.tf` -- API Gateway configuration for ingest endpoint
  - No wearable vendor BAA found in reviewed corpus.
- external dependency note: Executed BAAs are legal documents that would not normally be in a code repository. The AWS BAA screenshot is a captured artifact. The wearable vendor BAA may exist outside the codebase but must be confirmed.

---

### breach-notification

- finding state: Partial
- basis type: mixed
- severity: Minor
- addressable disposition: n/a
- observation: The system implements technical controls that support breach detection. CloudWatch alarms are configured for unauthorized access attempts, failed API calls, and CloudTrail log delivery failures. SNS notifications route these alarms to operations personnel. S3 Object Lock prevents deletion or modification of ingested health data, which preserves forensic evidence. CloudTrail provides a complete audit trail of all API activity on ePHI resources. KMS encryption at rest and TLS in transit may provide the encryption safe harbor (data rendered unusable, unreadable, or indecipherable to unauthorized persons per HHS guidance on unsecured PHI).

However, no formal breach notification procedure was found. No risk assessment framework for determining whether a breach is reportable under 164.402 was identified. No notification templates or timelines were documented. The entity type ambiguity affects breach notification obligations: CE notification obligations (164.404-408) differ from BA notification obligations (164.410). Without confirmed entity type, the specific notification requirements cannot be fully assessed. The encryption safe harbor may reduce the scope of reportable breaches but does not eliminate the need for a breach assessment procedure.

- what is still needed: Formal breach notification procedure. Risk assessment framework for breach determination (164.402 four-factor test). Notification templates and timeline documentation. Entity type confirmation to determine specific notification obligations (CE vs BA).
- recommendation: Establish a breach notification procedure covering the 164.402 risk assessment, adapted once entity type is confirmed. The strong detection controls (CloudWatch, CloudTrail, Object Lock) provide a solid technical foundation -- the gap is the organizational procedure that converts detection into assessment and notification. Document the encryption safe harbor basis (KMS at rest, TLS in transit) for the breach risk assessment.
- evidence reviewed:
  - `infrastructure/cloudwatch.tf` -- unauthorized access and audit failure alarms
  - `infrastructure/sns.tf` -- alarm notification routing
  - `infrastructure/s3.tf` -- Object Lock preserving forensic evidence
  - `infrastructure/cloudtrail.tf` -- complete API audit trail
  - `infrastructure/kms.tf` -- encryption at rest for safe harbor assessment
  - `infrastructure/api-gateway.tf` -- TLS in transit for safe harbor assessment
- external dependency note: Breach notification procedures are organizational controls. The technical detection layer is strong. Entity type confirmation is a prerequisite for determining the specific notification obligations.

---

### policies-procedures-documentation

- finding state: Partial
- basis type: missing_evidence
- severity: Minor
- addressable disposition: n/a
- observation: The repository contains extensive documentation: infrastructure-as-code with inline comments, a `docs/` directory with architecture diagrams and operational runbooks, and a `docs/baa-screenshots/` directory with captured BAA evidence. The documentation demonstrates a documentation-oriented culture. However, none of the documentation is formally approved, version-controlled with approval metadata, or tied to a document management lifecycle. No policies (as distinct from technical documentation) were found. No procedures for HIPAA-required processes (access management, incident response, breach notification, contingency operations) were found as standalone policy documents. The 164.316 documentation requirements specify that policies and procedures must be maintained in written form and retained for six years. The current documentation is technical and operational, not policy-grade.
- what is still needed: Formal HIPAA policies and procedures (not just technical documentation). Document approval and version control with approval metadata. Six-year retention policy for HIPAA-required documentation. Policy documents for each Security Rule administrative, physical, and technical safeguard area.
- recommendation: Establish a policy framework that converts the existing technical documentation into approved, version-controlled HIPAA policies. The infrastructure-as-code and operational documentation provide strong source material. Add approval metadata (author, reviewer, approval date, next review date) to each policy document. Establish a retention schedule meeting the six-year minimum.
- evidence reviewed:
  - `docs/` -- architecture diagrams, operational runbooks, BAA screenshots
  - `infrastructure/` -- well-documented infrastructure-as-code
  - No formal policies, approval metadata, or document lifecycle evidence found.
- external dependency note: Policy approval and document management are organizational processes. The strong existing documentation base reduces the effort required to establish formal policies.

---

### training-and-sanctions

- finding state: Not assessed
- basis type: missing_evidence
- severity: -
- addressable disposition: n/a
- observation: The reviewed corpus contains no training records, training materials, training policy, sanctions policy, or sanctions enforcement evidence. Security awareness and training (164.308(a)(5)) requires the standard to be implemented; its implementation specs (security reminders, malicious software protection, log-in monitoring, password management) are all addressable. Sanction policy (164.308(a)(1)(ii)(C)) is a required implementation spec under security management. These are organizational controls that typically live outside code repositories.
- what is still needed: Training program documentation. Training completion records. Sanctions policy. Sanctions enforcement evidence (if any sanctions have been applied). Addressable spec dispositions for the four training-related addressable specs.
- recommendation: Confirm whether training and sanctions programs exist outside the codebase. If they do, collect evidence for a follow-up assessment with external evidence. If they do not, establish both programs. Not assessed is the appropriate finding on repo-only evidence because no partial evidence of any kind was found.
- evidence reviewed:
  - No relevant files found in reviewed corpus.
- external dependency note: Training and sanctions are inherently organizational. Not assessed is the correct finding on repo-only evidence per the assessment rubric.

## Phased Remediation

**Phase 1 -- Entity classification (prerequisite for all other phases)**
- Conduct a formal entity type determination. Document whether the entity is a covered entity, business associate, BA subcontractor, or not regulated under HIPAA.
- If regulated, confirm applicable rules. If entity is a CE or BA handling PHI, add privacy_rule to applicable rules and re-evaluate the three excluded Privacy domains (privacy-uses-and-disclosures, minimum-necessary, individual-rights).
- This is the single highest-priority item. All other phases assume entity type is confirmed.

**Phase 2 -- Risk analysis and addressable-spec disposition**
- Conduct an organization-wide risk analysis per OCR guidance covering the Meridian pipeline's ePHI.
- Document risk management plan with control selection rationale for the existing strong technical controls (KMS, Object Lock, VPC isolation, IAM deny policies).
- Record addressable specification dispositions for all Security Rule addressable specs.
- Priority: risk analysis is the most common OCR enforcement finding.

**Phase 3 -- Organizational and contractual completion**
- Confirm or execute BAA with the wearable device vendor.
- Document the AWS BAA beyond the screenshot (retain the full executed agreement).
- Designate a security official (164.308(a)(2)).
- Establish incident response procedure building on the existing CloudWatch/SNS alerting.
- Establish breach notification procedure with 164.402 risk assessment framework.
- Document the cloud shared responsibility model for physical safeguards.

**Phase 4 -- Policy and documentation formalization**
- Convert existing technical documentation into formal HIPAA policies with approval metadata.
- Establish six-year document retention schedule.
- Confirm or establish training and sanctions programs.
- Collect training completion records.
- Establish workstation use and security policies.
- Conduct contingency plan testing and document results.
- Conduct periodic evaluation (164.308(a)(8)).

## Self-Review Confirmation

The following self-review checks from `core/checklists/assessment-self-review.md` were completed:

- [x] Content policy checked.
- [x] Entity type determined before setting assessment depth. Entity type is tbd with low confidence. Assessment proceeds conservatively: Security Rule and Breach Notification Rule assessed, Privacy-specific domains excluded.
- [x] Structured triage block produced before domain findings.
- [x] For every addressable Security Rule spec, addressable disposition was captured.
- [x] `missing_evidence` kept separate from `observed_gap` throughout. Organizational evidence not in repo is treated as missing evidence, not as observed gaps.
- [x] Repo-only realism rule applied for organizational controls (risk analysis, training, sanctions, physical safeguards rated Not assessed; organizational-requirements rated Partial because a BAA screenshot artifact was found).
- [x] Addressable specs not treated as gaps when disposition is undocumented in a repo-only review.
- [x] If `entity_type` is `tbd`, did I avoid pulling entity-gated Privacy domains? Yes. The three Privacy-specific domains (privacy-uses-and-disclosures, minimum-necessary, individual-rights) are excluded because entity_type is tbd and domain_selection_rules require confirmed entity type for those domains.
- [x] Output begins AND ends with the exact disclaimer.

This is a draft assessment for human compliance review. It is not a compliance determination and not a substitute for legal counsel.
