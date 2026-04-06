#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd -P)
RESOLVER="$ROOT/skills/hipaa-assessor/scripts/resolve-foundation-root.sh"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/hipaa-resolver.XXXXXX")

cleanup() {
  rm -rf "$TMP"
}
trap cleanup EXIT HUP INT TERM

fail() {
  echo "resolver smoke test failed: $*" >&2
  exit 1
}

canonical_path() {
  (
    cd "$1"
    pwd -P
  )
}

create_foundation() {
  base=$1
  mkdir -p "$base/core/index" "$base/core/applicability" "$base/skills/hipaa-assessor"
  : > "$base/core/index/domain-inventory.yaml"
  : > "$base/core/applicability/triage-output-template.yaml"
  : > "$base/skills/hipaa-assessor/SKILL.md"
}

run_resolver() {
  home=$1
  xdg=$2
  cwd=$3
  if [ $# -eq 4 ]; then
    env -i PATH="$PATH" HOME="$home" XDG_CONFIG_HOME="$xdg" HIPAA_FOUNDATION_ROOT="$4" \
      /bin/sh -c 'cd "$1" && /bin/sh "$2"' sh "$cwd" "$RESOLVER"
  else
    env -i PATH="$PATH" HOME="$home" XDG_CONFIG_HOME="$xdg" \
      /bin/sh -c 'cd "$1" && /bin/sh "$2"' sh "$cwd" "$RESOLVER"
  fi
}

assert_eq() {
  expected=$1
  actual=$2
  label=$3
  [ "$expected" = "$actual" ] || fail "$label: expected '$expected', got '$actual'"
}

assert_contains() {
  haystack=$1
  needle=$2
  label=$3
  printf '%s' "$haystack" | grep -F "$needle" >/dev/null || fail "$label: missing '$needle'"
}

# Priority 1: env var
home="$TMP/home-env"
xdg="$TMP/xdg-env"
cwd="$TMP/cwd-env"
foundation="$TMP/foundation-env"
mkdir -p "$home" "$xdg" "$cwd"
create_foundation "$foundation"
output=$(run_resolver "$home" "$xdg" "$cwd" "$foundation")
assert_eq "$(canonical_path "$foundation")" "$output" "priority 1 env var"

# Invalid env var fails closed
home="$TMP/home-invalid"
xdg="$TMP/xdg-invalid"
cwd="$TMP/cwd-invalid"
mkdir -p "$home" "$xdg" "$cwd"
if error_output=$(run_resolver "$home" "$xdg" "$cwd" "$TMP/does-not-exist" 2>&1 >/dev/null); then
  fail "invalid env var should fail closed"
fi
assert_contains "$error_output" "not a valid hipaa-foundation checkout" "invalid env var error"

# Priority 2: config file
home="$TMP/home-config"
xdg="$TMP/xdg-config"
cwd="$TMP/cwd-config"
foundation="$TMP/foundation-config"
mkdir -p "$home" "$xdg/hipaa-assessor" "$cwd"
create_foundation "$foundation"
printf '%s\n' "$(canonical_path "$foundation")" > "$xdg/hipaa-assessor/config"
output=$(run_resolver "$home" "$xdg" "$cwd")
assert_eq "$(canonical_path "$foundation")" "$output" "priority 2 config file"

# Priority 2: config file path with spaces
home="$TMP/home-config-space"
xdg="$TMP/xdg-config-space"
cwd="$TMP/cwd-config-space"
foundation="$TMP/foundation with space"
mkdir -p "$home" "$xdg/hipaa-assessor" "$cwd"
create_foundation "$foundation"
printf '%s\n' "$(canonical_path "$foundation")" > "$xdg/hipaa-assessor/config"
output=$(run_resolver "$home" "$xdg" "$cwd")
assert_eq "$(canonical_path "$foundation")" "$output" "priority 2 config file with spaces"

# Relative config file path fails closed
home="$TMP/home-config-relative"
xdg="$TMP/xdg-config-relative"
cwd="$TMP/cwd-config-relative"
mkdir -p "$home" "$xdg/hipaa-assessor" "$cwd"
printf '%s\n' "../hipaa-foundation" > "$xdg/hipaa-assessor/config"
if error_output=$(run_resolver "$home" "$xdg" "$cwd" 2>&1 >/dev/null); then
  fail "relative config path should fail closed"
fi
assert_contains "$error_output" "must contain a single-line absolute path" "relative config path error"

# Priority 3: well-known path
home="$TMP/home-well-known"
xdg="$TMP/xdg-well-known"
cwd="$TMP/cwd-well-known"
mkdir -p "$home/github" "$xdg" "$cwd"
create_foundation "$home/github/hipaa-foundation"
output=$(run_resolver "$home" "$xdg" "$cwd")
assert_eq "$(canonical_path "$home/github/hipaa-foundation")" "$output" "priority 3 well-known path"

# Priority 4: cwd is foundation repo
home="$TMP/home-cwd"
xdg="$TMP/xdg-cwd"
cwd="$TMP/foundation-cwd"
mkdir -p "$home" "$xdg"
create_foundation "$cwd"
output=$(run_resolver "$home" "$xdg" "$cwd")
assert_eq "$(canonical_path "$cwd")" "$output" "priority 4 cwd"

# Priority 5: sibling of repo root
home="$TMP/home-sibling-root"
xdg="$TMP/xdg-sibling-root"
repo_root="$TMP/workspace/target-repo"
cwd="$repo_root/app/subdir"
foundation="$TMP/workspace/hipaa-foundation"
mkdir -p "$home" "$xdg" "$cwd" "$repo_root"
touch "$repo_root/.git"
create_foundation "$foundation"
output=$(run_resolver "$home" "$xdg" "$cwd")
assert_eq "$(canonical_path "$foundation")" "$output" "priority 5 sibling of repo root"

# Priority 6: sibling of cwd
home="$TMP/home-sibling-cwd"
xdg="$TMP/xdg-sibling-cwd"
cwd="$TMP/loose/current-dir"
foundation="$TMP/loose/hipaa-foundation"
mkdir -p "$home" "$xdg" "$cwd"
create_foundation "$foundation"
output=$(run_resolver "$home" "$xdg" "$cwd")
assert_eq "$(canonical_path "$foundation")" "$output" "priority 6 sibling of cwd"

# Final failure output
home="$TMP/home-failure"
xdg="$TMP/xdg-failure"
cwd="$TMP/cwd-failure"
mkdir -p "$home" "$xdg" "$cwd"
if error_output=$(run_resolver "$home" "$xdg" "$cwd" 2>&1 >/dev/null); then
  fail "resolver should fail when no root can be resolved"
fi
assert_contains "$error_output" "Could not resolve hipaa-foundation." "failure message header"
assert_contains "$error_output" "Set HIPAA_FOUNDATION_ROOT env var" "failure option 1"
assert_contains "$error_output" "Write the path to" "failure option 2"
assert_contains "$error_output" "Clone to" "failure option 3"
assert_contains "$error_output" "Clone next to your target repo" "failure option 4"

printf 'resolver smoke tests passed\n'
