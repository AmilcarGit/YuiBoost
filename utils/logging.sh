#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

YUI_HOME="${YUI_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
YUI_LOG_DIR="$YUI_HOME/logs"
YUI_LOG_FILE="$YUI_LOG_DIR/yuiboost.log"
YUI_CHANGES_FILE="$YUI_HOME/backups/changes.log"

logging_init() {
    mkdir -p "$YUI_LOG_DIR" "$YUI_HOME/backups"
    [[ -f "$YUI_LOG_FILE" ]] || : > "$YUI_LOG_FILE"
    [[ -f "$YUI_CHANGES_FILE" ]] || : > "$YUI_CHANGES_FILE"
}

yui_log() {
    local level="$1"
    shift
    local msg="$*"
    logging_init
    printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$msg" >> "$YUI_LOG_FILE"
}

# Records a change so it can be undone later.
# Usage: record_change <target_file_or_key> <old_value> <new_value>
record_change() {
    local target="$1"
    local old_value="$2"
    local new_value="$3"
    logging_init
    printf '%s|%s|%s|%s\n' \
        "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$target" "$old_value" "$new_value" \
        >> "$YUI_CHANGES_FILE"
    yui_log "CHANGE" "target=$target old=$old_value new=$new_value"
}

has_recorded_changes() {
    logging_init
    [[ -s "$YUI_CHANGES_FILE" ]]
}
