# CLAUDE.md

This repository is a structured knowledge base for draft assessments of software systems against HIPAA (45 CFR Parts 160 and 164).

It is not a legal opinion, not a compliance determination, and not a substitute for legal counsel.

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

If the target system is outside this repository, resolve the foundation root first. Prefer `HIPAA_FOUNDATION_ROOT`.

If the foundation root cannot be resolved, stop and ask for the path.
