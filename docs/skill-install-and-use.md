# Skill Install And Use

## Fast path

For most users and fresh AI sessions, use this path:

1. Keep the repo in a durable checkout, not `/tmp`.

   ```text
   ${XDG_DATA_HOME:-$HOME/.local/share}/agent-skills/hipaa-foundation
   ```

2. Install the skill:

   ```sh
   ./install.sh
   ```

3. From any target repo, ask:

   ```text
   Do a full HIPAA draft assessment of this repo using the installed hipaa-assessor skill.
   ```

The installer writes the resolver config file, so agents can find this checkout from other repos.

## What gets installed

The root installer links only the reusable `hipaa-assessor` skill package and writes the resolver config path.

It does not copy the full `hipaa-foundation` corpus under `core/`.

That means the installed skill is not self-contained. You still need a separate accessible `hipaa-foundation` checkout.

Inside the installed skill package, use `START-HERE.md` and `references/index.yaml` as navigation surfaces only. The canonical corpus still lives in the resolved `hipaa-foundation` checkout.

## Install locations

```sh
./install.sh
```

Install targets:

- `$CODEX_HOME/skills/hipaa-assessor` when `CODEX_HOME` is set
- otherwise `~/.codex/skills/hipaa-assessor`
- `~/.claude/skills/hipaa-assessor`

## Upgrade the installed skill

If you update `hipaa-foundation`, rerun `./install.sh`.

## If you do not use the fast path

Use one of these alternatives:

- set `HIPAA_FOUNDATION_ROOT`
- write a single-line absolute path to `${XDG_CONFIG_HOME:-$HOME/.config}/hipaa-assessor/config`
- keep `hipaa-foundation` next to the target repo

## Foundation-root resolution details

The installed resolver checks, in order:

1. `HIPAA_FOUNDATION_ROOT`
2. `${XDG_CONFIG_HOME:-$HOME/.config}/hipaa-assessor/config`
3. `$HOME/github/hipaa-foundation`
4. the current working directory if it is the foundation repo
5. a sibling `hipaa-foundation` checkout next to the target repo root
6. a sibling `hipaa-foundation` checkout next to the current working directory

If no valid root is found, the assessment should stop and ask for the correct path.

## Advanced setup options

### Option 1: environment variable

```sh
export HIPAA_FOUNDATION_ROOT=/absolute/path/to/hipaa-foundation
```

This is the highest-priority override and fails closed if the path is invalid.

### Option 2: cross-tool config file

Write the absolute path to a single-line config file:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/hipaa-assessor"
printf '%s\n' "/absolute/path/to/hipaa-foundation" > "${XDG_CONFIG_HOME:-$HOME/.config}/hipaa-assessor/config"
```

Rules:

- single line only
- absolute path only
- no surrounding quotes

### Option 3: well-known path

Place the checkout at:

```text
$HOME/github/hipaa-foundation
```

This is a legacy zero-config convention. Prefer the fast path above.

### Option 4: adjacent clone

Place `hipaa-foundation` next to the target repo:

```text
~/code/github.com/nickzren/hipaa-foundation/
~/code/github.com/nickzren/your-target-system/
```

## Optional resolver check

From the installed skill directory, run:

For Codex:

```sh
${CODEX_HOME:-$HOME/.codex}/skills/hipaa-assessor/scripts/resolve-foundation-root.sh
```

For Claude Code:

```sh
~/.claude/skills/hipaa-assessor/scripts/resolve-foundation-root.sh
```

The command should print the resolved absolute path to the `hipaa-foundation` checkout.

## Target repo expectations

No target-repo-specific HIPAA metadata file is required.

The skill should inspect the target repo directly, including code, docs, infrastructure config, tests, and any architecture or procedure material present in the repo.

If the target repo does not contain enough evidence for a domain or implementation specification, the assessment should continue and use `Not assessed` or `Partial` instead of guessing.

## Prompt to use

From a target system repository, ask:

```text
Do a full HIPAA draft assessment of this repo using the installed hipaa-assessor skill.
```

If you want to be more explicit:

```text
Do a full HIPAA draft assessment of this repo using the installed hipaa-assessor skill. Follow the canonical workflow, produce the triage block before findings, and preserve unresolved evidence as Not assessed or Partial where required.
```

## Output expectations

Use these files from the resolved `hipaa-foundation` repository:

- `skills/hipaa-assessor/START-HERE.md`
- `skills/hipaa-assessor/references/index.yaml`
- `docs/assessment-output-template.md`
- `docs/example-assessment.md`
- `docs/example-assessment-ba.md`
- `docs/example-assessment-entity-tbd.md`
