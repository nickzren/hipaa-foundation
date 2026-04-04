# AGENTS.md

## Purpose

This repository is a public, structured knowledge base for producing draft HIPAA assessments of software systems against the Privacy Rule, Security Rule, and Breach Notification Rule (45 CFR Parts 160 and 164).

It is not a legal opinion, not an HHS/OCR endorsement, and not a substitute for legal counsel.

## Source hierarchy

1. 45 CFR text (eCFR) -- binding regulatory text
2. HHS/OCR guidance and FAQ -- enforcement posture and interpretive context
3. Repo interpretation -- non-authoritative assessment guidance
4. Target-system evidence -- determines the actual finding

## Key rules

- Always determine entity type before any domain review.
- Addressable does not mean optional. A documented exception backed by a risk analysis is not a gap.
- Distinguish missing evidence from observed gaps. Absence of evidence in a repo-only review is not the same as confirmed absence of the control.
- Many HIPAA obligations are organizational, not code-based. On repo-only evidence, these should typically be Not assessed or Partial, not Gap:
  - notices of privacy practices
  - authorizations and accounting of disclosures
  - executed BAAs
  - training completion records
  - breach investigation and notification workflow execution evidence
  - sanctions policy execution evidence
- Do not treat the Security Rule NPRM as current requirements.
- Do not produce findings for Part 162 in v1.

## Assessment workflow

Use `skills/hipaa-assessor/SKILL.md` as the canonical workflow.

## Key files

| File | Purpose |
|------|---------|
| `skills/hipaa-assessor/SKILL.md` | Canonical reusable assessment skill |
| `skills/hipaa-assessor/START-HERE.md` | Fast navigation surface |
| `skills/hipaa-assessor/references/index.yaml` | Machine-readable read order |
| `core/provenance/content-policy.yaml` | Content and licensing boundary |
| `core/applicability/triage.yaml` | Entity-role triage and domain selection rules |
| `core/applicability/triage-output-template.yaml` | Required triage output structure |
| `core/checklists/assessment-rubric.yaml` | Finding states, addressable rules, basis types |
| `core/checklists/evidence-map.yaml` | What to look for by domain |
| `core/checklists/assessment-self-review.md` | Mandatory final-pass checklist |
| `core/index/domain-inventory.yaml` | Canonical v1 domain set |
| `docs/assessment-output-template.md` | Required output shape |

## Cross-repo use

If the target system is outside this repository, resolve the foundation repo first:

1. Prefer `HIPAA_FOUNDATION_ROOT`
2. Otherwise use the current repository if you are already in `hipaa-foundation`
3. Otherwise use an adjacent `hipaa-foundation` clone

If the foundation root cannot be resolved, stop and ask for the path.

When used with `part11-foundation`:
- `hipaa-foundation` owns HIPAA Privacy/Security/Breach assessment
- `part11-foundation` owns Part 11 electronic record/signature assessment
- Keep factual evidence aligned, findings separate

When used with `gamp5-foundation`:
- `gamp5-foundation` owns lifecycle/validation/supplier methodology
- `hipaa-foundation` owns HIPAA rule-specific control assessment
- Risk analysis (HIPAA) and risk assessment (GAMP) are related but answer different questions
