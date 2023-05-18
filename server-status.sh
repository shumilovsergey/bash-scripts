#!/bin/bash

#input
read -p "Enter your Telegram bot token: " bot_token
read -p "Enter the chat ID: " chat_id

#ip
ip_address=$(curl -s https://api.ipify.org)
#pc name
computer_name=$(hostname)
#hdd
disk_avail=$(df -h --output=avail / | awk '{print$1}')
avail_d="Avail"
avail_multi=$(echo "$disk_avail" | sed "s/\b$avail_d\b//g")
avail="$(echo "$avail_multi" | tr -d '\n')"
disk_size=$(df -h --output=size / | awk '{print$1}')
size_d="Size"
size_multi=$(echo "$disk_size" | sed "s/\b$size_d\b//g")
size="$(echo "$size_multi" | tr -d '\n')"
#cpu
cpu_info=$(top -bn 1 | grep "Cpu(s)" | awk '{print $2}')
#ram
ram_info=$(free -m | grep "Mem:")
total_size=$(echo "$ram_info" | awk '{print $2}')
used_size=$(echo "$ram_info" | awk '{print $3}')
#tg
message="name: $computer_name \nip: $ip_address \nHDD: $size / $avail \nCPU: $cpu_info \nRAM: $total_size / $us>
curl -X POST -H "Content-Type: application/json" -d "{\"chat_id\":\"$chat_id\",\"text\":\"$message\"}" "https:/>


