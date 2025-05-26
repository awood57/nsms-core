#!/bin/bash

# Source the logger
source ../nsms-core/logger.sh

toggle_firewall() {
	echo "Toggling UFW firewall..."
	log_message "Toggling firewall" "SECURITY"
	sudo ufw status | grep -q "inactive" && sudo ufw enable || sudo ufw disable
}

view_rules() {
	echo "Viewing current UFW rules..."
	log_message "Viewing current UFW rules" "INFO"
	sudo ufw status numbered
}

add_new_rule() {
	read -p "Enter port/service/IP: " psip
	read -p "Allow or deny? (ALLOW/DENY): " action
	log_message "Adding rule: $action port/service/IP: $psip" "SECURITY"
	if [[ "$action" == "ALLOW" ]]; then
		sudo ufw allow "$psip"
	else
		sudo ufw deny "$psip"
	fi
}

delete_rule() {
	echo "Current rules:"
	log_message "Viewing UFW rules" "INFO"
	sudo ufw status numbered
	read -p "Enter rule number to delete: " rule_num
	log_message "Deleting rule: $rule_num" "SECURITY"
	sudo ufw delete "$rule_num"
}

edit_rules() {
	echo "Opening UFW config for editing..."
	log_message "Opening rules file in nano" "SECURITY"
	sudo nano /etc/ufw/user.rules
	echo "Don't forget to reload UFW if you made changes."
}

reset_firewall() {
	echo "Resetting UFW to default settings..."
	log_message "Firewall reset to default settings" "SECURITY"
	sudo ufw reset
}

show_logs() {
	echo "Showing UFW logs..."
	log_message "Displaying logs" "INFO"
	sudo journalctl -u ufw --no-pager
}

# Dispatcher
case "$1" in
toggle_firewall) toggle_firewall ;;
view_rules) view_rules ;;
add_new_rule) add_new_rule ;;
delete_rule) delete_rule ;;
edit_rules) edit_rules ;;
reset_firewall) reset_firewall ;;
show_logs) show_logs ;;
check_ufw_availability) check_ufw_availability ;;
*) echo -e "${RED}Invalid action: $1${NC}" ;;
esac
