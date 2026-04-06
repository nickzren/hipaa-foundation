# AGENTS.md

## Purpose

This repository is a public, structured knowledge base for producing draft HIPAA assessments of software systems against the Privacy Rule, Security Rule, and Breach Notification Rule (45 CFR Parts 160 and 164).

It is not a legal opinion, not an HHS/OCR endorsement, and not a substitute for legal counsel.

## How to use this repository

Use `skills/hipaa-assessor/SKILL.md` as the canonical reusable workflow.

`skills/SKILL.md` remains as a compatibility pointer for older references.

For fast navigation inside the reusable skill package, use `skills/hipaa-assessor/START-HERE.md` and `skills/hipaa-assessor/references/index.yaml`. They point back to canonical files; `core/` and `docs/` remain the source of truth.

Quick reference:
1. **Triage** — `core/applicability/triage.yaml` and produce a structured triage block per `core/applicability/triage-output-template.yaml`
2. **Domain selection** — `core/index/domain-inventory.yaml` using `domain_selection_rules`
3. **Evidence map** — consult `core/checklists/evidence-map.yaml` while exploring the target system
4. **Domain assessment** — selected `core/domains/*.yaml` files plus linked `core/regulations/*.yaml`; apply `core/checklists/assessment-rubric.yaml`
5. **Output** — use `docs/assessment-output-template.md`
6. **Self-review** — run `core/checklists/assessment-self-review.md` before finalizing

See worked examples:
- `docs/example-assessment.md` — covered entity assessment with repo-only evidence
- `docs/example-assessment-ba.md` — business associate assessment with external evidence
- `docs/example-assessment-entity-tbd.md` — conservative assessment when entity type is unconfirmed

## Source hierarchy

1. 45 CFR text (eCFR) — binding regulatory text
2. HHS/OCR guidance and FAQ — enforcement posture and interpretive context
3. Repo interpretation — non-authoritative assessment guidance
4. Target-system evidence — determines the actual finding

## Cross-repo use

If the target system is outside this repository, resolve the foundation repo first:

1. Use `docs/skill-install-and-use.md` as the canonical install and root-resolution guide.
2. Prefer `HIPAA_FOUNDATION_ROOT` when available.
3. Otherwise allow the installed resolver to use its config-file, well-known-path, cwd, and adjacent-clone fallbacks.
4. Explore the target repo directly before triage and use its code, docs, infra, and configuration as assessment evidence.

If the foundation root cannot be resolved, stop and ask for the path. If the root resolves but scope or governance evidence is incomplete, continue conservatively and use `Not assessed` or `Partial` where required instead of guessing.

## Portable skill

The installable assessment skill is `skills/hipaa-assessor/SKILL.md`.

Installation and cross-repo usage notes are in `docs/skill-install-and-use.md`.

## Key files

| File | Purpose |
|------|---------|
| `skills/hipaa-assessor/SKILL.md` | Canonical reusable assessment skill |
| `skills/hipaa-assessor/START-HERE.md` | Shortest-path navigation surface for the reusable skill |
| `skills/hipaa-assessor/references/index.yaml` | Machine-readable index of the assessment pack read order |
| `skills/SKILL.md` | Compatibility wrapper pointing to the canonical skill |
| `core/applicability/triage.yaml` | Step 0: determine entity type, PHI scope, and rule applicability |
| `core/applicability/triage-output-template.yaml` | Required triage output structure with enum fields |
| `core/index/domain-inventory.yaml` | Canonical list of all review domains |
| `core/domains/*.yaml` | Domain review files with questions, probes, and regulation links |
| `core/regulations/*.yaml` | Regulation nodes and implementation specifications |
| `core/checklists/assessment-rubric.yaml` | Finding-state and addressable-spec decision rules |
| `core/checklists/evidence-map.yaml` | What to look for per domain |
| `core/checklists/assessment-self-review.md` | Mandatory final-pass checklist |
| `core/provenance/source-manifest.yaml` | Canonical machine-readable source registry |
| `core/provenance/decision-log.yaml` | Rationale log for major rubric/schema/source decisions |
| `docs/assessment-output-template.md` | Required output format |
| `docs/example-assessment.md` | Worked example: covered entity |
| `docs/example-assessment-ba.md` | Worked example: business associate |
| `docs/example-assessment-entity-tbd.md` | Worked example: entity type uncertain |
| `docs/skill-install-and-use.md` | Install and cross-repo usage instructions |

## Key rules

- Always determine entity type before any domain review.
- Addressable does not mean optional. A documented exception backed by a risk analysis is not a gap.
- Distinguish missing evidence from observed gaps. Absence of evidence in a repo-only review is not the same as confirmed absence of the control.
- Many HIPAA obligations are organizational, not code-based. On repo-only evidence, these should typically be `Not assessed` or `Partial`, not `Gap`:
  - notices of privacy practices
  - authorizations and accounting of disclosures
  - executed BAAs
  - training completion records
  - breach investigation and notification workflow execution evidence
  - sanctions policy execution evidence
- Do not treat the Security Rule NPRM as current requirements.
- Do not produce findings for Part 162 in v1.
- When target-repo evidence is incomplete, continue on assessable domains and prefer conservative findings over interactive follow-up unless truly blocked.

## Cross-foundation use

When used with `part11-foundation`:
- `hipaa-foundation` owns HIPAA Privacy/Security/Breach assessment
- `part11-foundation` owns Part 11 electronic record/signature assessment
- keep factual evidence aligned, findings separate

When used with `gamp5-foundation`:
- `gamp5-foundation` owns lifecycle/validation/supplier methodology
- `hipaa-foundation` owns HIPAA rule-specific control assessment
- HIPAA risk analysis and GAMP risk assessment are related but answer different questions
