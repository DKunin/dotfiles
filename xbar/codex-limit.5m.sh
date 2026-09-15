#!/bin/bash

# <xbar.title>Codex usage limit</xbar.title>
# <xbar.version>v1.0.0</xbar.version>
# <xbar.author>Dmitry Kunin</xbar.author>
# <xbar.desc>Shows the remaining Codex quota through the default SOCKS proxy.</xbar.desc>
# <xbar.dependencies>bash,curl,jq</xbar.dependencies>
# <xbar.abouturl>https://developers.openai.com/codex/</xbar.abouturl>

set -o pipefail

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

CODEX_AUTH_FILE="${CODEX_AUTH_FILE:-$HOME/.codex/auth.json}"
SOCKS_PROXY_CONFIG="${SOCKS_PROXY_CONFIG:-$HOME/Library/Application Support/telegram-via-socks/proxy-config.json}"
CODEX_USAGE_URL="${CODEX_USAGE_URL:-https://chatgpt.com/backend-api/wham/usage}"

show_error() {
    local message="$1"

    printf 'Codex ⚠\n'
    printf '%s\n' '---'
    printf 'Codex limit unavailable\n'
    printf '%s | color=red\n' "$message"
    printf 'Refresh | refresh=true\n'
}

window_label() {
    case "$1" in
        18000) printf '5 hours' ;;
        86400) printf 'Daily' ;;
        604800) printf 'Weekly' ;;
        2592000 | 2678400) printf 'Monthly' ;;
        *)
            if [ "$1" -ge 3600 ] 2>/dev/null; then
                printf '%s hours' "$(( $1 / 3600 ))"
            else
                printf '%s minutes' "$(( $1 / 60 ))"
            fi
            ;;
    esac
}

format_reset() {
    LC_ALL=C date -r "$1" '+%a %d %b, %H:%M' 2>/dev/null || printf 'unknown'
}

print_window() {
    local used_percent="$1"
    local window_seconds="$2"
    local reset_at="$3"
    local remaining label reset

    remaining=$((100 - used_percent))
    [ "$remaining" -lt 0 ] && remaining=0
    [ "$remaining" -gt 100 ] && remaining=100
    label=$(window_label "$window_seconds")
    reset=$(format_reset "$reset_at")

    printf '%s: %s%% remaining | color=%s\n' "$label" "$remaining" "$(quota_color "$remaining")"
    printf -- '--Resets %s\n' "$reset"
}

quota_color() {
    if [ "$1" -le 10 ]; then
        printf 'red'
    elif [ "$1" -le 25 ]; then
        printf 'orange'
    else
        printf 'green'
    fi
}

render_usage() {
    local json="$1"
    local remaining plan balance limit_name current_limit used window reset

    remaining=$(printf '%s' "$json" | jq -er '
        [.rate_limit.primary_window, .rate_limit.secondary_window]
        | map(select(. != null) | (100 - (.used_percent // 0) | floor))
        | min
    ') || return 1
    [ "$remaining" -lt 0 ] && remaining=0
    [ "$remaining" -gt 100 ] && remaining=100

    printf 'Codex %s%% | color=%s\n' "$remaining" "$(quota_color "$remaining")"
    printf '%s\n' '---'
    printf 'Main quota\n'

    while IFS=$'\t' read -r used window reset; do
        [ -n "$used" ] && print_window "$used" "$window" "$reset"
    done < <(printf '%s' "$json" | jq -r '
        [.rate_limit.primary_window, .rate_limit.secondary_window]
        | map(select(. != null))[]
        | [((.used_percent // 0) | floor), .limit_window_seconds, .reset_at]
        | @tsv
    ')

    current_limit=''
    while IFS=$'\t' read -r limit_name used window reset; do
        [ -z "$limit_name" ] && continue
        limit_name=${limit_name//|/-}
        if [ "$limit_name" != "$current_limit" ]; then
            printf '%s\n' '---'
            printf '%s\n' "$limit_name"
            current_limit="$limit_name"
        fi
        print_window "$used" "$window" "$reset"
    done < <(printf '%s' "$json" | jq -r '
        .additional_rate_limits[]? as $limit
        | [$limit.rate_limit.primary_window, $limit.rate_limit.secondary_window]
        | map(select(. != null))[]
        | [$limit.limit_name, ((.used_percent // 0) | floor), .limit_window_seconds, .reset_at]
        | @tsv
    ')

    plan=$(printf '%s' "$json" | jq -r '.plan_type // empty')
    balance=$(printf '%s' "$json" | jq -r '.credits.balance // empty | tonumber? | (.*100 | round / 100)')
    printf '%s\n' '---'
    [ -n "$plan" ] && printf 'Plan: %s | color=gray\n' "${plan//|/-}"
    [ -n "$balance" ] && printf 'Credits: %s | color=gray\n' "$balance"
    printf 'Refresh | refresh=true\n'
}

fetch_usage() {
    local proxy_protocol proxy_host proxy_port proxy_user proxy_password proxy_url
    local access_token account_id response_file http_code

    command -v jq >/dev/null 2>&1 || { show_error 'jq is not installed'; return; }
    command -v curl >/dev/null 2>&1 || { show_error 'curl is not installed'; return; }
    [ -r "$CODEX_AUTH_FILE" ] || { show_error 'Run codex login first'; return; }
    [ -r "$SOCKS_PROXY_CONFIG" ] || { show_error 'SOCKS proxy config not found'; return; }

    proxy_protocol=$(jq -er '.protocol' "$SOCKS_PROXY_CONFIG" 2>/dev/null) || { show_error 'Invalid SOCKS proxy config'; return; }
    [ "$proxy_protocol" = 'socks5' ] || { show_error 'Proxy must use SOCKS5'; return; }
    proxy_host=$(jq -er '.host | @uri' "$SOCKS_PROXY_CONFIG" 2>/dev/null) || { show_error 'Proxy host is missing'; return; }
    proxy_port=$(jq -er '.port' "$SOCKS_PROXY_CONFIG" 2>/dev/null) || { show_error 'Proxy port is missing'; return; }
    case "$proxy_port" in
        '' | *[!0-9]*) show_error 'Proxy port is invalid'; return ;;
    esac
    if [ "$proxy_port" -lt 1 ] || [ "$proxy_port" -gt 65535 ]; then
        show_error 'Proxy port is invalid'
        return
    fi
    proxy_user=$(jq -r '(.username // "") | @uri' "$SOCKS_PROXY_CONFIG" 2>/dev/null) || return
    proxy_password=$(jq -r '(.password // "") | @uri' "$SOCKS_PROXY_CONFIG" 2>/dev/null) || return

    access_token=$(jq -er '.tokens.access_token' "$CODEX_AUTH_FILE" 2>/dev/null) || { show_error 'Run codex login again'; return; }
    account_id=$(jq -er '.tokens.account_id' "$CODEX_AUTH_FILE" 2>/dev/null) || { show_error 'Codex account ID is missing'; return; }

    if [ -n "$proxy_user" ] || [ -n "$proxy_password" ]; then
        proxy_url="socks5h://$proxy_user:$proxy_password@$proxy_host:$proxy_port"
    else
        proxy_url="socks5h://$proxy_host:$proxy_port"
    fi

    response_file=$(mktemp "${TMPDIR:-/tmp}/xbar-codex-limit.XXXXXX") || { show_error 'Cannot create temporary file'; return; }
    trap 'rm -f "$response_file"' EXIT

    http_code=$(
        printf 'proxy = "%s"\nheader = "Authorization: Bearer %s"\nheader = "ChatGPT-Account-Id: %s"\n' \
            "$proxy_url" "$access_token" "$account_id" |
            curl \
                --config - \
                --silent \
                --show-error \
                --connect-timeout 10 \
                --max-time 25 \
                --output "$response_file" \
                --write-out '%{http_code}' \
                --header @- \
                --header 'Accept: application/json' \
                "$CODEX_USAGE_URL" 2>/dev/null
    )

    if [ "$http_code" = '401' ]; then
        show_error 'Codex login expired; open Codex to refresh it'
    elif [ "$http_code" != '200' ]; then
        show_error "API request failed (HTTP ${http_code:-network error})"
    elif ! render_usage "$(<"$response_file")"; then
        show_error 'Unexpected API response'
    fi
}

if [ "${CODEX_LIMIT_TEST_MODE:-0}" != '1' ]; then
    fetch_usage
fi
