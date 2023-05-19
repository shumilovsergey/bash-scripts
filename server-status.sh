#!/bin/bash

#INPUT
read -p "Enter your Telegram bot token: " bot_token
read -p "Enter the chat ID: " chat_id

#VAR
file_name="sh-serv-info.sh"
folder_name="sh-bash"
cron_time="0 6 * * *"

#WORK_DIR
mkdir "$folder_name"
cd "$folder_name" || exit

#WRITING_SCRIPT
echo "#!/bin/bash" > "$file_name"
echo "#input" >> "$file_name"
echo "bot_token=$bot_token" >> "$file_name"
echo "chat_id=$chat_id" >> "$file_name"
echo "#ip" >> "$file_name"
echo "ip_address=\$(curl -s https://api.ipify.org)" >> "$file_name"
echo "#pc name" >> "$file_name"
echo "computer_name=\$(hostname)" >> "$file_name"
echo "#hdd" >> "$file_name"
echo "disk_avail=\$(df -h --output=avail / | awk '{print\$1}')" >> "$file_name"
echo "avail_d=\"Avail\"" >> "$file_name"
echo "avail_multi=\$(echo \"\$disk_avail\" | sed \"s/\\\b\$avail_d\\\b//g\")" >> "$file_name"
echo "avail=\"\$(echo \"\$avail_multi\" | tr -d '\\\n')\"" >> "$file_name"
echo "disk_size=\$(df -h --output=size / | awk '{print\$1}')" >> "$file_name"
echo "size_d=\"Size\"" >> "$file_name"
echo "size_multi=\$(echo \"\$disk_size\" | sed \"s/\\\b\$size_d\\\b//g\")" >> "$file_name"
echo "size=\"\$(echo \"\$size_multi\" | tr -d '\\\n')\"" >> "$file_name"
echo "#cpu" >> "$file_name"
echo "cpu_info=\$(top -bn 1 | grep \"Cpu(s)\" | awk '{print \$2}')" >> "$file_name"
echo "#ram" >> "$file_name"
echo "ram_info=\$(free -m | grep \"Mem:\")" >> "$file_name"
echo "total_size=\$(echo \"\$ram_info\" | awk '{print \$2}')" >> "$file_name"
echo "used_size=\$(echo \"\$ram_info\" | awk '{print \$3}')" >> "$file_name"
echo "#tg" >> "$file_name"
echo "message=\"name: \$computer_name \\\nip: \$ip_address \\\nHDD: \$size / \$avail \\\nCPU: \$cpu_info \\\nRAM: \$total_size / \$used_size mB\"" >> "$file_name"
echo "curl -X POST -H \"Content-Type: application/json\" -d \"{\\\"chat_id\\\":\\\"\$chat_id\\\",\\\"text\\\":\\\"\$message\\\"}\" \"https://api.telegram.org/bot\$bot_token/sendMessage\"" >> "$file_name"

chmod +x "$file_name"
file_path=$(pwd)"/$file_name"
echo "$file_path"

#CRON_TASK
(crontab -l 2>/dev/null; echo "$cron_time $file_path") | crontab -
echo "Cron task added: $cron_time $file_name"

