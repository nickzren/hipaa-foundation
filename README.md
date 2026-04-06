# hipaa-foundation

[![Status: draft](https://img.shields.io/badge/status-draft-orange)](./AGENTS.md)
[![Validation: fail-closed](https://img.shields.io/badge/validation-fail--closed-green)](./scripts/validate.rb)
[![Source: eCFR 45 CFR Parts 160, 162, 164](https://img.shields.io/badge/source-eCFR%2045%20CFR-blue)](./core/provenance/source-manifest.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow)](./LICENSE)

A reusable HIPAA assessment skill for AI agents. Same regulation, structured for agent use and human review.

You bring the agent (Claude Code, Codex, etc.) and a target system. This repo tells it how to assess that system against the HIPAA Privacy Rule, Security Rule, and Breach Notification Rule conservatively, with cited sources, addressable-spec awareness, and explicit entity-type and scope uncertainty handling.

This is not a legal opinion and not a compliance oracle.

## Quick start

1. Keep this repo at:

   ```
   $HOME/github/hipaa-foundation
   ```

2. Install the skill once:

   ```sh
   ./scripts/install-codex-skill.sh
   ./scripts/install-claude-skill.sh
   ```

3. No target-repo-specific HIPAA metadata file is required. The skill should inspect the target repo directly.

4. Point your agent at the target repo:

   ```
   Do a full HIPAA draft assessment of this repo using the installed hipaa-assessor skill.
   ```

5. The agent follows the skill workflow: entity-role triage -> domain selection -> evidence map -> findings -> self-review.

6. Get a structured draft assessment with a triage block, domain ratings summary, detailed findings for every non-Adequate domain, and phased remediation.

For fallback resolver options such as `HIPAA_FOUNDATION_ROOT`, config-file setup, or adjacent-clone layout, use `docs/skill-install-and-use.md`.

## What's inside

```
core/
  applicability/      Entity-role triage and machine-readable output template
  checklists/         Assessment rubric, evidence map, self-review checklist
  domains/            12 domain-level review files (hybrid rule-family + functional)
  index/              Domain inventory
  provenance/         Source manifest, decision log, content policy

skills/
  hipaa-assessor/     The reusable assessment skill (workflow + navigation)

docs/
  assessment-output-template.md
  skill-install-and-use.md
```

## How agents use it

- **Codex**: reads `AGENTS.md` as the direct-use contract
- **Claude Code**: reads `CLAUDE.md` as the bootstrap, then `AGENTS.md`
- **Both**: follow `skills/hipaa-assessor/SKILL.md` as the canonical workflow

The skill starts with entity-role triage (covered entity, BA, or not regulated), determines which rules apply, selects only relevant domains, checks addressable vs. required for Security Rule specs, applies a rating rubric, and runs a self-review checklist before finalizing.

For fast navigation inside the skill package, agents use `skills/hipaa-assessor/START-HERE.md` and `skills/hipaa-assessor/references/index.yaml`.

## Install as a portable skill

```sh
./scripts/install-claude-skill.sh   # -> ~/.claude/skills/hipaa-assessor/
./scripts/install-codex-skill.sh    # -> $CODEX_HOME/skills/hipaa-assessor/
```

The installed skill is **not self-contained**. It still needs an accessible `hipaa-foundation` checkout.

Use `docs/skill-install-and-use.md` as the canonical install and root-resolution guide. It documents:

- all six resolver priorities
- the cross-tool config file path and format
- the well-known path convention
- adjacent-clone fallback
- resolver verification commands

## Assessment discipline

- **Entity type before depth.** Determine covered entity, business associate, BA subcontractor, or not regulated before selecting domains or making findings.
- **Addressable is not optional.** Addressable specs require assessment, but a documented alternative or exception is not a gap by itself.
- **Repo-only realism.** Many HIPAA obligations are organizational, not code-based. On repo-only evidence, these should typically be `Not assessed` or `Partial`, not `Gap`.
- **Scope uncertainty propagates.** If entity type or PHI classification is provisional, downstream findings inherit that uncertainty.
- **Every finding cites its source.** CFR text, OCR guidance, and repo interpretation are always distinguished.
- **Self-review before output.** A mandatory checklist catches overconfidence before the assessment is finalized.

## Source baseline

- **Regulation text**: eCFR, 45 CFR Parts 160, 162, 164
- **Guidance**: HHS/OCR HIPAA for Professionals
- **Pending**: Security Rule NPRM (not effective, tracked only); CMS Part 162 final rule (March 20, 2026; effective May 26, 2026)
- **Provenance**: `core/provenance/source-manifest.yaml`
- **Decision history**: `core/provenance/decision-log.yaml`

## Validation

```sh
make validate
```

Or directly:

```sh
ruby scripts/validate.rb
```

Validation is fail-closed. Checks: required files, content policy, decision log, triage schema, rubric states, evidence map structure, domain inventory and files, reference index, schema versions, operator-surface alignment, and enum consistency.

## Licensing

MIT
