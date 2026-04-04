# hipaa-foundation

[![Status: draft](https://img.shields.io/badge/status-draft-orange)](./AGENTS.md)
[![Validation: fail-closed](https://img.shields.io/badge/validation-fail--closed-green)](./scripts/validate.rb)
[![Source: eCFR 45 CFR Parts 160, 162, 164](https://img.shields.io/badge/source-eCFR%2045%20CFR-blue)](./core/provenance/source-manifest.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow)](./LICENSE)

A reusable HIPAA assessment skill for AI agents. Same regulation, structured for agent use and human review.

You bring the agent (Claude Code, Codex, etc.) and a target system. This repo tells it how to assess that system against the HIPAA Privacy Rule, Security Rule, and Breach Notification Rule -- conservatively, with cited sources, addressable-spec awareness, and explicit entity-type and scope uncertainty handling.

This is not a legal opinion and not a compliance oracle.

## Quick start

1. Clone this repo alongside your target system, or set `HIPAA_FOUNDATION_ROOT`:

   ```
   ~/github/hipaa-foundation/
   ~/github/your-target-system/
   ```

   Or:

   ```sh
   export HIPAA_FOUNDATION_ROOT=/path/to/hipaa-foundation
   ```

2. Point your agent at it:

   ```
   Assess this system against HIPAA using the hipaa-foundation repo.
   ```

3. The agent follows the skill workflow: content policy check -> entity-role triage -> domain selection -> evidence map -> findings -> self-review.

4. Get a structured draft assessment with a triage block, domain ratings (including addressable disposition for Security Rule specs), detailed findings, and phased remediation.

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

The skill starts with entity-role triage (covered entity, BA, or not regulated?), determines which rules apply, selects only relevant domains, checks addressable vs. required for Security Rule specs, applies a rating rubric, and runs a self-review checklist before finalizing.

For fast navigation inside the skill package, agents use `skills/hipaa-assessor/START-HERE.md` and `skills/hipaa-assessor/references/index.yaml`.

## Install as a portable skill

```sh
./scripts/install-claude-skill.sh   # -> ~/.claude/skills/hipaa-assessor/
./scripts/install-codex-skill.sh    # -> $CODEX_HOME/skills/hipaa-assessor/
```

The installed skill is **not self-contained** -- it needs an accessible `hipaa-foundation` checkout. Set `HIPAA_FOUNDATION_ROOT` or place it adjacent to your target repo.

## Assessment discipline

- **Entity type before depth.** Determine covered entity, business associate, or not regulated before selecting domains or making findings.
- **Addressable is not optional.** Addressable specs require assessment -- but a documented exception is not a gap. The rubric enforces this.
- **Repo-only realism.** Many HIPAA obligations are process-heavy. Absence of privacy notices, BAAs, or training records from a code repo is not automatically a gap.
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

Validation is fail-closed. Checks: required files, content policy, decision log, triage schema, rubric states, evidence map structure, domain inventory and files, reference index, and schema versions.

## Licensing

MIT
