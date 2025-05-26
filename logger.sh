#!/bin/bash
# Set log directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"
export LOG_FILE
# Initialize session ID
SESSION_ID=$(date +%s)
export SESSION_ID

log_message() {
	local message="$1"
	local level="${2:-INFO}"
	local timestamp
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	echo "[$timestamp] [$level] $message" >>"$LOG_FILE"
	if [[ "$level" == "ERROR" || "$level" == "WARNING" || "$level" == "SECURITY" ]]; then
		echo "[$timestamp] [$level] $message" >&2
	fi
}

log_session_start() {
	local timestamp
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	local user
	user=$(whoami)
	{
		echo ""
		echo "=================================================="
		echo "[$timestamp] SESSION STARTED - User: $user - Session ID: $SESSION_ID"
		echo "=================================================="
	} >>"$LOG_FILE"
	# Output session ID to stdout
	echo "$SESSION_ID"
}

log_session_end() {
	local timestamp
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	{
		echo "=================================================="
		echo "[$timestamp] SESSION ENDED - Session ID: $SESSION_ID"
		echo "=================================================="
		echo ""
	} >>"$LOG_FILE"
}

log_tool_exec() {
	local tool_name="$1"
	local timestamp
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	echo "[$timestamp] [INFO] Executing tool: $tool_name - Session ID: $SESSION_ID" >>"$LOG_FILE"
}

export -f log_message
export -f log_session_start
export -f log_session_end
export -f log_tool_exec
