#!/bin/bash

check_ufw() {
    if ! command -v ufw &>/dev/null; then
        echo "NOT INSTALLED"
        return
    fi

    status=$(ufw status | head -n 1)
    if [[ "$status" == "Status: active" ]]; then
        echo "ONLINE"
    else
        echo "OFFLINE"
    fi
}

check_fail2ban() {
    if ! command -v fail2ban-client &>/dev/null; then
        echo "NOT INSTALLED"
        return
    fi

    if systemctl is-active --quiet fail2ban &>/dev/null; then
        echo "ONLINE"
    else
        echo "OFFLINE"
    fi
}


check_suricata() {
    if ! command -v suricata &>/dev/null; then
        echo "NOT INSTALLED"
        return
    fi

    if systemctl is-active --quiet suricata; then
        echo "ONLINE"
    else
        echo "OFFLINE"
    fi
}

check_tcpdump() {
    if ! command -v tcpdump &>/dev/null; then
        echo "NOT INSTALLED"
        return
    else
        echo "AVAILABLE"
    fi
}

case "$1" in
    ufw) check_ufw ;;
    fail2ban) check_fail2ban ;;
    suricata) check_suricata ;;
    tcpdump) check_tcpdump ;;
    *)
        echo "NOT INSTALLED"
        ;;
esac
