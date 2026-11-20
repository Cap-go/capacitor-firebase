#!/usr/bin/env bash

set -euo pipefail

ensure_repo_label() {
  local repo="$1"
  local name="$2"
  local color="$3"
  local description="$4"

  if gh api "repos/${repo}/labels/${name}" >/dev/null 2>&1; then
    return 0
  fi

  gh label create "$name" \
    --repo "$repo" \
    --color "$color" \
    --description "$description" >/dev/null 2>&1 || {
    echo "Warning: could not create label '${name}'"
    return 1
  }
}

ensure_sync_labels() {
  local repo="$1"

  ensure_repo_label "$repo" upstream-sync 1d76db "Automated sync from upstream changes" || true
  ensure_repo_label "$repo" automated 0e8a16 "Fully automated workflow-managed change" || true
  ensure_repo_label "$repo" needs-attention b60205 "Needs human follow-up" || true
  ensure_repo_label "$repo" merge-conflict d93f0b "Merge conflict detected during automation" || true
}

repo_has_issues() {
  local repo="$1"
  gh api "repos/${repo}" --jq '.has_issues' 2>/dev/null || echo "false"
}

create_pr_and_capture_number() {
  local repo="$1"
  local base="$2"
  local head="$3"
  local title="$4"
  local body="$5"

  gh pr create \
    --repo "$repo" \
    --base "$base" \
    --head "$head" \
    --title "$title" \
    --body "$body" >/dev/null

  gh pr list \
    --repo "$repo" \
    --state open \
    --base "$base" \
    --head "$head" \
    --json number \
    -q '.[0].number'
}

add_labels_to_pr() {
  local repo="$1"
  local pr_number="$2"
  shift 2

  if [ "$#" -eq 0 ]; then
    return 0
  fi

  local csv
  csv=$(printf '%s,' "$@")
  csv=${csv%,}

  gh pr edit "$pr_number" --repo "$repo" --add-label "$csv" >/dev/null 2>&1 || {
    echo "Warning: could not add labels '${csv}' to PR #${pr_number}"
    return 1
  }
}

issue_reports_upstream_sha() {
  local repo="$1"
  local issue_number="$2"
  local upstream_sha="$3"

  if [ -z "$upstream_sha" ] || [ -z "$issue_number" ]; then
    return 1
  fi

  local payload
  payload="$(gh issue view "$issue_number" --repo "$repo" --json body,comments 2>/dev/null || true)"
  if [ -z "$payload" ]; then
    return 1
  fi

  if printf '%s' "$payload" | jq -e --arg sha "$upstream_sha" '
      (.body | contains($sha))
      or ((.comments // []) | any(.body; contains($sha)))
    ' >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

find_open_conflict_issue_for_upstream_sha() {
  local repo="$1"
  local upstream_sha="$2"

  if [ -z "$upstream_sha" ]; then
    return 1
  fi

  local issue_numbers
  issue_numbers=$(
    gh issue list \
      --repo "$repo" \
      --state open \
      --label merge-conflict \
      --json number \
      -q '.[].number' 2>/dev/null || true
  )

  if [ -z "$issue_numbers" ]; then
    return 1
  fi

  local issue_number
  for issue_number in $issue_numbers; do
    if issue_reports_upstream_sha "$repo" "$issue_number" "$upstream_sha"; then
      echo "$issue_number"
      return 0
    fi
  done

  return 1
}

create_or_update_conflict_issue() {
  local repo="$1"
  local title="$2"
  local body="$3"
  local upstream_sha="${4:-}"
  local search_text="Upstream sync requires manual conflict resolution in:title"

  if [ "$(repo_has_issues "$repo")" != "true" ]; then
    return 1
  fi

  local existing_issue=""
  if [ -n "$upstream_sha" ]; then
    existing_issue="$(find_open_conflict_issue_for_upstream_sha "$repo" "$upstream_sha" || true)"
  fi

  if [ -z "$existing_issue" ]; then
    existing_issue=$(
      gh issue list \
        --repo "$repo" \
        --state open \
        --search "$search_text" \
        --json number \
        -q '.[0].number' 2>/dev/null || true
    )
  fi

  if [ -n "$existing_issue" ]; then
    if [ -n "$upstream_sha" ]; then
      if issue_reports_upstream_sha "$repo" "$existing_issue" "$upstream_sha"; then
        echo "Open conflict issue #${existing_issue} already covers upstream ${upstream_sha}"
        echo "$existing_issue"
        return 0
      fi
    fi
    gh issue comment "$existing_issue" --repo "$repo" --body "$body" >/dev/null 2>&1 || return 1
    echo "$existing_issue"
    return 0
  fi

  gh issue create \
    --repo "$repo" \
    --title "$title" \
    --body "$body" \
    --label upstream-sync \
    --label merge-conflict \
    --label needs-attention >/dev/null 2>&1 || return 1

  gh issue list \
    --repo "$repo" \
    --state open \
    --search "$search_text" \
    --json number \
    -q '.[0].number'
}
