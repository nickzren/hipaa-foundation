#!/usr/bin/env sh
set -eu

is_foundation_root() {
  candidate=$1
  [ -f "$candidate/core/index/domain-inventory.yaml" ] &&
    [ -f "$candidate/core/applicability/triage-output-template.yaml" ] &&
    [ -f "$candidate/skills/hipaa-assessor/SKILL.md" ]
}

print_resolved() {
  cd "$1"
  pwd -P
  exit 0
}

find_repo_root() {
  dir=$1
  while :; do
    [ -e "$dir/.git" ] && { echo "$dir"; return 0; }
    parent=$(dirname "$dir")
    [ "$parent" = "$dir" ] && break
    dir=$parent
  done
  return 1
}

if [ "${HIPAA_FOUNDATION_ROOT:-}" ]; then
  if is_foundation_root "$HIPAA_FOUNDATION_ROOT"; then
    print_resolved "$HIPAA_FOUNDATION_ROOT"
  else
    echo "HIPAA_FOUNDATION_ROOT is set to '$HIPAA_FOUNDATION_ROOT' but it is not a valid hipaa-foundation checkout." >&2
    exit 1
  fi
fi

cwd=$(pwd -P)
if is_foundation_root "$cwd"; then
  print_resolved "$cwd"
fi

if repo_root=$(find_repo_root "$cwd"); then
  sibling_dir="$(dirname "$repo_root")/hipaa-foundation"
  if [ -d "$sibling_dir" ] && is_foundation_root "$sibling_dir"; then
    print_resolved "$sibling_dir"
  fi
fi

parent_dir=$(dirname "$cwd")
sibling_dir="$parent_dir/hipaa-foundation"
if [ -d "$sibling_dir" ] && is_foundation_root "$sibling_dir"; then
  print_resolved "$sibling_dir"
fi

echo "Could not resolve hipaa-foundation. Set HIPAA_FOUNDATION_ROOT to an accessible checkout or place a hipaa-foundation clone next to the target repo." >&2
exit 1
