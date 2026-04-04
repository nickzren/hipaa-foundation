# Skill Install and Use

## Install into Claude Code

```sh
./scripts/install-claude-skill.sh
```

## Install into Codex

```sh
./scripts/install-codex-skill.sh
```

## Important

The installed skill is not self-contained.

Keep a separate accessible `hipaa-foundation` checkout and prefer:

```sh
export HIPAA_FOUNDATION_ROOT=/absolute/path/to/hipaa-foundation
```

Or place `hipaa-foundation` adjacent to the target repo.

## Cross-repo use

When both `hipaa-foundation` and `part11-foundation` are available:
- use `hipaa-foundation` for HIPAA Privacy/Security/Breach assessment
- use `part11-foundation` for Part 11 electronic record/signature assessment
- systems handling ePHI under FDA predicate rules may need both
- keep factual evidence aligned, findings separate

When both `hipaa-foundation` and `gamp5-foundation` are available:
- use `gamp5-foundation` for lifecycle / validation / supplier / maintained-state review
- use `hipaa-foundation` for HIPAA rule-specific control assessment
- HIPAA risk analysis and GAMP risk assessment are related but answer different questions
