#!/bin/bash

#UPDATE
sudo apt update -y
sudo apt upgrade -y

#TIMESHIFT "CLEAN-SERVER"
sudo apt install timeshift -y
sudo timeshift --create --comment "CLEAN-SERVER"
echo "----------------------------------------------------------------"
echo "\nTimeshift created CLEAN-SERVER backup"
echo "----------------------------------------------------------------"

#SWAP
fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
free -h
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo "----------------------------------------------------------------"
echo "\nAllocated swap file"
echo "----------------------------------------------------------------"

#GIT
sudo apt install git -y
echo "----------------------------------------------------------------"
echo "\nInstalled Git"
echo "----------------------------------------------------------------"

#GitHub CLI
sudo apt update -y
sudo apt install git -y
git --version
curl -Lso /var/tmp/gh.deb "https://github.com/cli/cli/releases/download/v2.14.6/gh_2.14.6_linux_amd64.deb"
sudo dpkg -i /var/tmp/gh.deb
rm /var/tmp/gh.deb
gh --version
echo "----------------------------------------------------------------"
echo "\nInstalled GitHub CLI"
echo "----------------------------------------------------------------"

#DOCKER
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
echo "----------------------------------------------------------------"
echo "\nInstalled Docker"
echo "----------------------------------------------------------------"

#SERVER-STATUS
read -p "Enter your Telegram bot token: " bot_token
read -p "Enter the chat ID: " chat_id

file_name="sh-serv-info.sh"
folder_name="sh-bash"
cron_time="0 6 * * *"

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
echo "----------------------------------------------------------------"
echo "\nInstalled server-status"
echo "----------------------------------------------------------------"


#TIMESHIFT "SETUP-SERVER"
timeshift --create --comment "SETUP-SERVER"
echo "----------------------------------------------------------------"
echo "\nTimeshift created SETUP-SERVER backup"
echo "----------------------------------------------------------------"

# Clean up
rm ./main-setup.sh
echo "----------------------------------------------------------------"
echo "\nInstallation completed!"
echo "----------------------------------------------------------------"
