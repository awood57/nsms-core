#!/bin/bash

source ../nsms-core/logger.sh

live_capture() {
    read -p "Enter interface (e.g., eth0): " interface
    read -p "Enter filter expression (or leave blank): " filter_expr
    read -p "Enter packet count: " packet_count

    if [[ -z "$interface" || -z "$packet_count" ]]; then
        echo "Interface and packet count are required."
        return 1
    fi

    echo "Capturing $packet_count packets on interface '$interface'..."
    sudo tcpdump -i "$interface" $filter_expr -c "$packet_count"
}

live_pcap_capture() {
    read -p "Enter interface (e.g., eth0): " interface
    read -p "Enter filter expression (or leave blank): " filter_expr
    read -p "Enter output file name (e.g., capture.pcap): " output_file
    read -p "Enter packet count: " packet_count
    read -p "Enter duration in seconds: " duration

    if [[ -z "$interface" || -z "$output_file" || -z "$packet_count" || -z "$duration" ]]; then
        echo "All fields are required."
        return 1
    fi

    echo "Starting live capture on $interface (filter: '$filter_expr') for $duration seconds or $packet_count packets..."
    sudo timeout "$duration" tcpdump -i "$interface" $filter_expr -c "$packet_count" -U -w - | tee >(tcpdump -r -) > "$output_file"
}

list_interfaces() {
    echo "Available network interfaces:"
    sudo tcpdump -D
}

show_tcpdump_help() {
    tcpdump --help | less
}

case "$1" in
    list_interfaces) list_interfaces ;;
    live_capture) live_capture ;;
    live_pcap_capture) live_pcap_capture ;;
    show_tcpdump_help) show_tcpdump_help ;;
    *) echo -e "${RED}Invalid action: $1${NC}" ;;
esac
