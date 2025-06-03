#!/bin/bash

SURICATA_LOG_PATH="/var/log/suricata/fast.log"
SURICATA_STATS_PATH="/var/log/suricata/stats.log"
SURICATA_CONFIG_PATH="/etc/suricata/suricata.yaml"

# Source the logger
source ../nsms-core/logger.sh

toggle_suricata() {
	echo "Toggling Suricata..."
	log_message "Toggling Suricata IDS" "SECURITY"

	if systemctl is-active --quiet suricata; then
		systemctl stop suricata
		log_message "Suricata stopped." "SECURITY"
	else
		systemctl start suricata
		log_message "Suricata started." "SECURITY"
	fi
}

restart_suricata() {
	log_message "Restarting Suricata..." "SECURITY"
	systemctl restart suricata
}

view_fast_log() {
	log_message "Opening Suricata fast.log" "INFO"
	if [[ -f "$SURICATA_LOG_PATH" ]]; then
		less "$SURICATA_LOG_PATH"
	else
		echo -e "\e[31mfast.log not found at $SURICATA_LOG_PATH\e[0m"
		sleep 2
	fi
}

view_stats_log() {
	log_message "Opening Suricata stats.log" "INFO"
	if [[ -f "$SURICATA_STATS_PATH" ]]; then
		less "$SURICATA_STATS_PATH"
	else
		echo -e "\e[31mstats.log not found at $SURICATA_STATS_PATH\e[0m"
		sleep 2
	fi
}

edit_config() {
	log_message "Editing Suricata configuration" "INFO"
	if [[ -f "$SURICATA_CONFIG_PATH" ]]; then
		local editor="${EDITOR:-nano}"
		"$editor" "$SURICATA_CONFIG_PATH"
	else
		echo -e "\e[31mConfiguration file not found at $SURICATA_CONFIG_PATH\e[0m"
		sleep 2
	fi
}

update_rules() {
	log_message "Updating Suricata rules using suricata-update" "SECURITY"
	if ! command -v suricata-update &>/dev/null; then
		echo -e "\e[31msuricata-update not installed. Install it to update rules.\e[0m"
	else
		suricata-update
	fi
}

# Dispatcher
case "$1" in
toggle_suricata) toggle_suricata ;;
view_fast_log) view_fast_log ;;
view_stats_log) view_stats_log ;;
edit_config) edit_config ;;
update_rules) update_rules ;;
restart_suricata) restart_suricata ;;
*) echo -e "${RED}Invalid action: $1${NC}" ;;
esac
