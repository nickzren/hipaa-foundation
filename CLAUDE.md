# CLAUDE.md

This repository is a structured knowledge base for draft assessments of software systems against HIPAA (45 CFR Parts 160 and 164).

It is not a legal opinion, not a compliance determination, and not a substitute for legal counsel.

Use this file as the Claude Code bootstrap for this repository:

- Start with entity-role triage before selecting domains.
- Produce a structured triage block per `core/applicability/triage-output-template.yaml`.
- Use `AGENTS.md` as the canonical shared contract for workflow, discipline rules, and prohibited shortcuts.
- Use `skills/hipaa-assessor/SKILL.md` as the reusable workflow layer.
- For fast navigation inside the reusable skill, use `skills/hipaa-assessor/START-HERE.md` and `skills/hipaa-assessor/references/index.yaml`.
- Apply `core/checklists/assessment-rubric.yaml` for every finding.
- Consult `core/checklists/evidence-map.yaml` while exploring the target system.
- Use `docs/assessment-output-template.md` for output structure.
- Run `core/checklists/assessment-self-review.md` before finalizing.
- If the target system is outside this repository, resolve the foundation root first using `docs/skill-install-and-use.md`. Prefer `HIPAA_FOUNDATION_ROOT`, but allow the config-file, well-known-path, cwd, and adjacent-clone fallbacks.

Worked examples:
- `docs/example-assessment.md` — covered entity with repo-only evidence
- `docs/example-assessment-ba.md` — business associate with external evidence
- `docs/example-assessment-entity-tbd.md` — entity type uncertain, conservative scope

Source hierarchy:

- `core/regulations/*.yaml` `authoritative_text` — binding CFR text
- `core/guidance/*.yaml` — OCR interpretive context
- `core/domains/*.yaml` and checklist files — non-authoritative assessment guidance
- target-system evidence — determines the actual finding

Claude-specific notes:

- Do not skip triage.
- Do not infer entity type from branding, clinical function, or health-data content alone.
- Do not treat addressable specs as optional.
- Do not collapse missing evidence and observed gaps into one vague finding.
- Do not convert provisional entity type or PHI scope into a final claim.
- Every non-Adequate, non-Not-applicable finding must have its own detailed section. Do not skip any.
- If the foundation root cannot be resolved, stop and ask for the path.
- If evidence is incomplete but the foundation root resolves, continue conservatively and use `Not assessed` or `Partial` where required instead of asking avoidable follow-up questions.
