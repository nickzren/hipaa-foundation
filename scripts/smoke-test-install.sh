#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd -P)
SOURCE_DIR="$ROOT/skills/hipaa-assessor"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/hipaa-install.XXXXXX")

cleanup() {
  rm -rf "$TMP"
}
trap cleanup EXIT HUP INT TERM

fail() {
  echo "install smoke test failed: $*" >&2
  exit 1
}

assert_exists() {
  path=$1
  [ -e "$path" ] || fail "missing expected path: $path"
}

assert_executable() {
  path=$1
  [ -x "$path" ] || fail "expected executable path: $path"
}

assert_tree_matches() {
  source_path=$1
  installed_path=$2
  if ! diff_output=$(diff -qr "$source_path" "$installed_path" 2>&1); then
    printf '%s\n' "$diff_output" >&2
    fail "installed skill content drifted from source"
  fi
}

run_codex_install() {
  home=$1
  xdg=$2
  codex_home=$3
  env -i PATH="$PATH" HOME="$home" XDG_CONFIG_HOME="$xdg" CODEX_HOME="$codex_home" \
    /bin/sh -c 'cd "$1" && /bin/sh ./scripts/install-codex-skill.sh' sh "$ROOT"
}

run_claude_install() {
  home=$1
  xdg=$2
  env -i PATH="$PATH" HOME="$home" XDG_CONFIG_HOME="$xdg" \
    /bin/sh -c 'cd "$1" && /bin/sh ./scripts/install-claude-skill.sh' sh "$ROOT"
}

# Codex install in a clean environment
codex_home="$TMP/codex-home"
home="$TMP/codex-user"
xdg="$TMP/codex-xdg"
mkdir -p "$codex_home" "$home" "$xdg"
run_codex_install "$home" "$xdg" "$codex_home" >/dev/null
codex_dest="$codex_home/skills/hipaa-assessor"
assert_exists "$codex_dest/SKILL.md"
assert_exists "$codex_dest/START-HERE.md"
assert_exists "$codex_dest/references/index.yaml"
assert_exists "$codex_dest/scripts/resolve-foundation-root.sh"
assert_executable "$codex_dest/scripts/resolve-foundation-root.sh"
assert_tree_matches "$SOURCE_DIR" "$codex_dest"

# Claude install in a clean environment
home="$TMP/claude-user"
xdg="$TMP/claude-xdg"
mkdir -p "$home" "$xdg"
run_claude_install "$home" "$xdg" >/dev/null
claude_dest="$home/.claude/skills/hipaa-assessor"
assert_exists "$claude_dest/SKILL.md"
assert_exists "$claude_dest/START-HERE.md"
assert_exists "$claude_dest/references/index.yaml"
assert_exists "$claude_dest/scripts/resolve-foundation-root.sh"
assert_executable "$claude_dest/scripts/resolve-foundation-root.sh"
assert_tree_matches "$SOURCE_DIR" "$claude_dest"

printf 'install smoke tests passed\n'
