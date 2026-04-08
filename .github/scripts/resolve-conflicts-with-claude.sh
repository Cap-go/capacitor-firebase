#!/usr/bin/env bash

set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo "Claude conflict resolution skipped: ANTHROPIC_API_KEY is not configured"
  exit 1
fi

BASE_BRANCH="${1:-unknown}"
INCOMING_REF="${2:-unknown}"
SYNC_CONTEXT="${3:-upstream sync}"

mapfile -t conflicted_files < <(git diff --name-only --diff-filter=U)

if [ "${#conflicted_files[@]}" -eq 0 ]; then
  echo "No unresolved merge conflicts found"
  exit 0
fi

PROMPT_FILE="$(mktemp)"
trap 'rm -f "$PROMPT_FILE"' EXIT

{
  echo "You are resolving Git merge conflicts in the current repository."
  echo
  echo "Context:"
  echo "- Base branch: ${BASE_BRANCH}"
  echo "- Incoming ref: ${INCOMING_REF}"
  echo "- Sync context: ${SYNC_CONTEXT}"
  echo
  echo "Repository rules:"
  echo "1. Resolve every current merge conflict in the working tree."
  echo "2. Preserve Capgo-specific package scopes, namespaces, repository URLs, release workflow, and publishing customizations."
  echo "3. When upstream adds files under io.capawesome or @capacitor-firebase, adapt them to the Capgo fork conventions used by nearby files."
  echo "4. Prefer upstream runtime and API behavior when possible, unless that would remove an intentional Capgo fork customization."
  echo "5. Keep both sides of changelog or README content when both are still relevant."
  echo "6. Do not leave conflict markers in any file."
  echo "7. Stage the resolved files with git add, but do not create a commit."
  echo "8. Do not modify unrelated files."
  echo "9. When done, print exactly one line starting with RESOLVED: and a short summary."
  echo "10. If you cannot finish cleanly, print exactly one line starting with UNRESOLVED: and explain why."
  echo
  echo "Current unresolved files:"
  printf '%s\n' "${conflicted_files[@]}"
} > "$PROMPT_FILE"

CLAUDE_OUTPUT="$(
  claude -p \
    --bare \
    --permission-mode bypassPermissions \
    --add-dir "$PWD" \
    "$(cat "$PROMPT_FILE")" 2>&1
)" || {
  echo "$CLAUDE_OUTPUT"
  exit 1
}

echo "$CLAUDE_OUTPUT"

if git diff --name-only --diff-filter=U | grep -q .; then
  echo "Claude conflict resolution left unresolved files"
  exit 1
fi

for path in "${conflicted_files[@]}"; do
  if [ -f "$path" ] && grep -nE '^(<<<<<<<|=======|>>>>>>>)' "$path" >/dev/null; then
    echo "Conflict markers remain in ${path}"
    exit 1
  fi
done

git diff --check >/dev/null
