#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CODEX_LIMIT_TEST_MODE=1 source "$SCRIPT_DIR/codex-limit.5m.sh"

assert_contains() {
    local output="$1"
    local expected="$2"

    if [[ "$output" != *"$expected"* ]]; then
        printf 'Expected output to contain: %s\nActual output:\n%s\n' "$expected" "$output" >&2
        exit 1
    fi
}

weekly_json='{
  "plan_type": "prolite",
  "rate_limit": {
    "primary_window": {"used_percent": 6, "limit_window_seconds": 604800, "reset_at": 1788154307},
    "secondary_window": null
  },
  "credits": {"balance": "132.2906420000"},
  "additional_rate_limits": []
}'

output=$(render_usage "$weekly_json")
assert_contains "$output" 'Codex 94% | color=green'
assert_contains "$output" 'Weekly: 94% remaining'
assert_contains "$output" 'Credits: 132.29'

two_windows_json='{
  "rate_limit": {
    "primary_window": {"used_percent": 92, "limit_window_seconds": 18000, "reset_at": 1788154307},
    "secondary_window": {"used_percent": 30, "limit_window_seconds": 604800, "reset_at": 1788154307}
  },
  "additional_rate_limits": [{
    "limit_name": "Codex|Spark",
    "rate_limit": {
      "primary_window": {"used_percent": 25, "limit_window_seconds": 18000, "reset_at": 1788154307},
      "secondary_window": null
    }
  }]
}'

output=$(render_usage "$two_windows_json")
assert_contains "$output" 'Codex 8% | color=red'
assert_contains "$output" '5 hours: 8% remaining'
assert_contains "$output" 'Weekly: 70% remaining'
assert_contains "$output" 'Codex-Spark'

printf 'codex-limit tests passed\n'
