#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd -P)
SOURCE_DIR="$ROOT/skills/hipaa-assessor"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Missing skill source directory: $SOURCE_DIR" >&2
  exit 1
fi

CODEX_ROOT=${CODEX_HOME:-"$HOME/.codex"}
DEST_DIR="$CODEX_ROOT/skills/hipaa-assessor"

mkdir -p "$(dirname "$DEST_DIR")"
rm -rf "$DEST_DIR"
cp -R "$SOURCE_DIR" "$DEST_DIR"
chmod +x "$DEST_DIR/scripts/resolve-foundation-root.sh"

printf 'Installed or updated hipaa-assessor to %s\n' "$DEST_DIR"
printf 'This installs the workflow layer only, not the knowledge base.\n'
printf 'Re-run this script after updating hipaa-foundation to refresh the installed skill.\n'
printf 'Keep a separate accessible hipaa-foundation checkout and prefer:\n'
printf '  export HIPAA_FOUNDATION_ROOT="%s"\n' "$ROOT"
printf 'Resolver docs:\n'
printf '  %s\n' "$ROOT/docs/skill-install-and-use.md"
printf 'Uninstall with:\n'
printf '  rm -rf "%s"\n' "$DEST_DIR"
