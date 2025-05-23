#!/bin/bash
# Set log directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
export LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"
# Initialize session ID
export SESSION_ID=$(date +%s)

log_message() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    if [[ "$level" == "ERROR" || "$level" == "WARNING" || "$level" == "SECURITY" ]]; then
        echo "[$timestamp] [$level] $message" >&2
    fi
}

log_session_start() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local user=$(whoami)
    echo "" >> "$LOG_FILE"
    echo "==================================================" >> "$LOG_FILE"
    echo "[$timestamp] SESSION STARTED - User: $user - Session ID: $SESSION_ID" >> "$LOG_FILE"
    echo "==================================================" >> "$LOG_FILE"
}

log_session_end() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "==================================================" >> "$LOG_FILE"
    echo "[$timestamp] SESSION ENDED - Session ID: $SESSION_ID" >> "$LOG_FILE"
    echo "==================================================" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
}

log_tool_exec() {
    local tool_name="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [INFO] Executing tool: $tool_name - Session ID: $SESSION_ID" >> "$LOG_FILE"
}


export -f log_message
export -f log_session_start
export -f log_session_end
export -f log_tool_exec
