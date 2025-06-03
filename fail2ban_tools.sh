#!/bin/bash

# Source the logger
source ../nsms-core/logger.sh

toggle_fail2ban() {
	if systemctl is-active --quiet fail2ban; then
		echo "Stopping Fail2ban..."
		log_message "Stopping Fail2ban" "SECURITY"
		systemctl stop fail2ban
	else
		echo "Starting Fail2ban..."
		log_message "Starting Fail2ban" "SECURITY"
		systemctl start fail2ban
	fi
}

view_active_jails() {
	echo "Active Fail2ban jails:"
	log_message "Viewing active jails" "INFO"
	fail2ban-client status | grep 'Jail list' | cut -d: -f2
}

view_fail2ban_logs() {
	local log_file="/var/log/fail2ban.log"
	log_message "Viewing fail2ban logs" "INFO"
	if [[ -f "$log_file" ]]; then
		less "$log_file"
	else
		echo "Fail2ban log not found at $log_file"
		sleep 2
	fi
}

search_logs_for_ip() {
	local ip="$1"
	local log_file="/var/log/fail2ban.log"

	if [[ -z "$ip" ]]; then
		echo "Usage: search_logs_for_ip <IP_ADDRESS>"
		return 1
	fi

	echo "Searching for IP $ip in Fail2ban logs..."
	log_message "Searching logs for $ip"
	grep "$ip" "$log_file" || echo "No entries found for $ip"
}

# Unban an IP
unban_ip() {
	local ip="$1"

	if [[ -z "$ip" ]]; then
		echo "Usage: unban_ip <IP_ADDRESS>"
		return 1
	fi

	# List jails
	local jails=$(fail2ban-client status | grep 'Jail list' | cut -d: -f2 | tr ',' '\n' | awk '{$1=$1};1')

	for jail in $jails; do
		echo "Attempting to unban $ip from jail: $jail"
		log_message "Unbanning $ip from jail: $jail" "SECURITY"
		fail2ban-client set "$jail" unbanip "$ip"
	done
}

edit_fail2ban_config() {
	local config_file="/etc/fail2ban/jail.local"
	log_message "Editing fail2ban config" "INFO"

	if [[ -f "$config_file" ]]; then
		${EDITOR:-nano} "$config_file"
	else
		echo "Fail2ban config not found at $config_file"
		sleep 2
	fi
}

restart_fail2ban() {
	echo "Restarting Fail2ban..."
	log_message "Restarting Fail2ban" "SECURITY"
	systemctl restart fail2ban
}

# Dispatcher
case "$1" in
toggle_fail2ban) toggle_fail2ban ;;
view_active_jails) view_active_jails ;;
view_fail2ban_logs) view_fail2ban_logs ;;
search_logs_for_ip) search_logs_for_ip ;;
unban_ip) unban_ip ;;
edit_fail2ban_conmfig) edit_fail2ban_config ;;
restart_fail2ban) restart_fail2ban ;;
*) echo -e "${RED}Invalid Action: $1${NC}" ;;
esac
