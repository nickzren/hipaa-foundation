# Manual Acceptance Harness

Use this runbook to verify that a fresh Codex or Claude Code session can use the installed `hipaa-assessor` skill without extra setup hints.

These fixtures are for operator testing only. They are non-canonical and live under `test/fixtures/`.

## Preconditions

1. Install the portable skill:
   - `./scripts/install-codex-skill.sh`
   - `./scripts/install-claude-skill.sh`
2. Make the foundation repo resolvable using one of the supported methods in `docs/skill-install-and-use.md`.
3. Verify the installed resolver from a clean shell if needed:
   - `${CODEX_HOME:-$HOME/.codex}/skills/hipaa-assessor/scripts/resolve-foundation-root.sh`
   - `~/.claude/skills/hipaa-assessor/scripts/resolve-foundation-root.sh`

## Fixtures

- `test/fixtures/minimal-target`
  Minimal synthetic target with incomplete evidence.
- `test/fixtures/rich-target`
  Synthetic target with richer architecture and operational material but no target-repo-specific HIPAA metadata.

## Codex manual acceptance

### Fixture 1: `test/fixtures/minimal-target`

1. Start a fresh Codex session in `test/fixtures/minimal-target`.
2. Ask:

   ```text
   Do a full HIPAA draft assessment of this repo using the installed hipaa-assessor skill.
   ```

3. Pass criteria:
   - the session resolves `hipaa-foundation` without shell-specific hints
   - the assessment starts with entity-role triage
   - the output includes the structured triage block before domain findings
   - missing governance or scope evidence becomes `Not assessed` or `Partial` as appropriate
   - the session does not stop for avoidable questions

### Fixture 2: `test/fixtures/rich-target`

1. Start a fresh Codex session in `test/fixtures/rich-target`.
2. Ask:

   ```text
   Do a full HIPAA draft assessment of this repo using the installed hipaa-assessor skill.
   ```

3. Pass criteria:
   - the session digs into repo docs, code, and infra before finalizing triage
   - entity-role triage happens before domain findings
   - the output preserves provisional scope and uses `Not assessed` or `Partial` where required

## Claude Code manual acceptance

Repeat the same two fixture runs in fresh Claude Code sessions.

Pass criteria are identical:

- no extra setup hints required beyond installed-skill discovery
- entity-role triage occurs before domain findings
- the session explores target-repo evidence directly
- missing evidence produces conservative findings instead of overconfident conclusions

## Failure conditions

Any of the following is a failed acceptance run:

- the session cannot resolve `hipaa-foundation`
- the session skips entity-role triage
- the session invents final entity type or full scope where the fixture leaves scope provisional
- the session asks avoidable setup questions when the repo already contains enough information to continue conservatively
