# Test Fixtures

These fixtures are synthetic operator-test targets for the installed `hipaa-assessor` skill.

They are non-canonical and exist only to support manual Codex and Claude Code acceptance runs.

- `minimal-target` keeps evidence intentionally sparse.
- `rich-target` includes more code, docs, and infrastructure evidence.

No fixture includes a target-repo-specific HIPAA metadata file. The skill is expected to inspect the fixture repo directly.
