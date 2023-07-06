#!/bin/bash
if [ -z "$SUDO_PASSWORD" ]; then
    # Yêu cầu người dùng nhập mật khẩu
    echo "Enter your password to run the script as root:"
    read -s SUDO_PASSWORD
    # Thiết lập biến môi trường cho mật khẩu root
    export SUDO_PASSWORD
    # Sử dụng sudo để chạy lại script với quyền root
    sudo -E bash "$0"
    exit
fi
# Tiếp tục thực thi script dưới quyền root
echo "Running script as root..."
echo
YELLOW='\033[1;33m'
NC='\033[0m' # Mã màu mặc định
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
GREENs='\033[1;32m'
echo -e "${CYAN}        .^~!?JJYYYYYYYJJ?7~^:                                                                       "
sleep 0.1
echo -e "${CYAN}   :~7YPPPP5YJ?77!!!77?JY5PPPPY?~:                                                                 "
sleep 0.1
echo -e "${CYAN}  ?GG5J!^.. ..:^^^^^^^::. ..^!?5GGJ                                                                 "
sleep 0.1
echo -e "${CYAN}  JGP:  !?Y5PPPPPPPPPPPPP5Y?!  .GBJ   ...          ....    ...       ........         ....          "
sleep 0.1
echo -e "${CYAN}  ~GG~ .PBG!^::.......::^!PBP:  !Y!   ?P55^       JP55^ ~J5PPP5J!.  ?P55PPPPP5.  .~?Y5PPPP5?~.      "
sleep 0.1
echo -e "${CYAN}  .5GY  !GG~             .YPG5J~.     .5GGP:     7GGG7 7GGGJ7?5GG?  JGGGJJJJJ?. !5GBG5J?JYPBB5:     "
sleep 0.1
echo -e "${CYAN}   !GG7!YGGP^           .. .^75GG~     :PGGY    ~GGGJ  JBGG!.  ^.   JGGP.      7GGGJ:     .!!:      "
sleep 0.1
echo -e "${CYAN}    JGGGJ!YBP^         ^PP5?^. :!.      ~GGG?  :PGGY.  .75GGG5J!^   JGGG55555..PGG5                 "
sleep 0.1
echo -e "${CYAN}     JGP^  JGG7       !GGJ?5GPJ:         7GGG~ YGG5:      :~7YPGGY: JGGPYJYYJ..PGG5.                "
sleep 0.1
echo -e "${CYAN}      ?GG7  !PB5~   ^YBP!  7GGJ.          ?GGPJGGP^   .^!?:   !GGBJ JGGP.      !GGGY^.    :77^      "
sleep 0.1
echo -e "${CYAN}       ~PBY^ .7PB57YGP?. :YBP!             YGGGGG~    .YBBGYJJPGGP^ JGGG5YYYY5: ~YGBGPYYY5GBGY:     "
sleep 0.1
echo -e "${CYAN}        :JGGJ: .!5G57. :?GGJ:              .YYYY7       ^?Y5P5YJ!.  7YYYYYYYY5^   ^7JY5P55J7^       "
sleep 0.1
echo -e "${CYAN}          ^JGGJ~  :  ^JGGJ^                                                                         "
sleep 0.1
echo -e "${CYAN}            :?PGP?~?PGP?:                          ${NC}Thr3at Hunt1ng T00lk1t - by VSEC , for VSEC      "
sleep 0.1
echo -e "${CYAN}              .^?PGPJ~.                                                                             "
sleep 0.1
echo -e "${CYAN}                 .:.                                                                                "

sleep 1
echo -e "------------------------------------\033[1;31mT1548.001 Privilege Escalation${CYAN}----------------------------------${NC}"
echo -e "${CYAN}--------------------------------------${NC}List binary SUID or SGID${CYAN}--------------------------------------${NC}"
echo "Listting....."
OUTPUT1=$(find / -xdev -type f \( -perm -04000 -o -perm -02000 \))
echo "${OUTPUT1}"

sleep 1
echo -e "${CYAN}---------------------\033[1;31mT1037.004 Boot or Logon Initialization Scripts: RC Scripts${CYAN}---------------------${NC}"
echo -e "${CYAN}--------------------------${NC}RC Scripts: rc.local: Are the content suspicious${CYAN}--------------------------${NC}"
OUTPUT=$(cat /etc/rc.local)
echo "${OUTPUT}"
echo -e "${CYAN}--------------------------${NC}RC Scripts: rc.common: Are the content suspicious${CYAN}--------------------------${NC}"
OUTPUT=$(cat /etc/rc.common)
echo "${OUTPUT}"
echo
echo
sleep 1
echo -e "${CYAN}---------------------------\033[1;31mT1053.003 Execution and Persistence via Cronjob${CYAN}---------------------------${NC}"
echo -e "${CYAN}------------------------------${NC}Colleting Cronjob Systeam (/etc/crontab)${CYAN}-------------------------------"
# Lấy giá trị biến $PATH trong crontab
path_value=$(grep -E "^PATH=" /etc/crontab | awk -F'=' '{print $2}')
echo
# In ra giá trị của biến $PATH trong crontab
echo -e "${CYAN}[*] Giá trị của biến PATH trong /etc/crontab${NC}"
sleep 0.5
echo " => $path_value"
echo
sleep 0.4
echo -e "${CYAN}[*] Quyền của tất cả các PATH trong /etc/crontab${NC}"

# Tìm và in ra quyền của các giá trị trong biến $PATH
#IFS=":" read -ra path_entries <<< "$path_value"
#for path_entry in "${path_entries[@]}"; do
#    permissions=$(ls -ld "$path_entry" 2>/dev/null | awk '{print $1}')
#    echo "Path: $path_entry"
#   echo "Permissions: $permissions"
#   echo
#done

IFS=":" read -ra path_entries <<< "$path_value"



for path_entry in "${path_entries[@]}"; do
    permissions=$(ls -ld "$path_entry" 2>/dev/null | awk '{print $1}')
    

    # Kiểm tra quyền write cho group user và other user
    if [[ $permissions =~ ....w..w. ]]; then
    	sleep 0.2
        echo -e " ${YELLOW}[!]Path: $path_entry"
        echo -e " =>${RED}Permissions: $permissions${NC}"
        sleep 0.2
    else 
    	echo -e " ${GREEN}Path: $path_entry "
    	echo -e " ${GREEN}Permissions: $permissions${NC}"
    fi

    echo
done

# Liệt kê các binary trong crontab
#echo -e "${CYAN}[*] Danh sách các binary đang được lên lịch cronjob ( chưa filter )${NC}"
binary_list=$(grep -E -v "^\s*#" /etc/crontab | awk '{print $7}' | sort -u)
#echo -e " \e[32m$binary_list\e[0m"
#echo
echo -e "${CYAN}[*] Danh sách Path của các binary có quyền thực thi đang được lên lịch cronjob${NC}"

# Tìm vị trí của các binary trong biến $PATH
#echo "Binary paths:"
IFS=":" read -ra path_array <<< "$path_value"  # Chuyển chuỗi path_value thành mảng các đường dẫn

for binary in $binary_list; do
    found=0  # Biến đánh dấu binary có tồn tại trong ít nhất một path hay không

    for path in "${path_array[@]}"; do
        if [ -x "$path/$binary" ]; then
            permissions=$(stat -c "%A" "$path/$binary")
            write_permissions=$(echo "$permissions" | cut -c6-8)

            # Kiểm tra quyền write cho group user và other user
            if [[ $write_permissions == *w?* || $write_permissions == *??w* ]]; then
            	sleep 0.2
                echo -e " \e[33;1m[!]File '$binary' exists in path '$path' with permissions: $permissions\e[0m"
                sleep 0.1
            else
            	sleep 0.2
                echo -e " \e[32m[+]File '$binary' exists in path '$path' with permissions: $permissions\e[0m"
            fi

            found=1
        fi
    done
done
sleep 1
echo
echo -e "${CYAN}------------------------------${NC}Colleting binary Cronjob for all user${CYAN}-------------------------------${NC}"
echo
sleep 1
users=$(cut -d: -f1 /etc/passwd)
for user in $users; do
    crontab_content=$(sudo -u $user crontab -l 2>/dev/null)
    if [ -n "$crontab_content" ]; then
        echo -e "${GREENs}=> User: $user${NC}"
        echo -e "${CYAN}[*]PATH:${NC} \e[32m$PATH${NC}"
        echo -e "${CYAN}[*]Cronjobs:${NC}"
        sleep 0.3
        # Lọc và in ra danh sách cronjob đã loại bỏ các comment
        echo "$crontab_content" | awk '!/^#/ {print}'
        path=$(echo "$crontab_content" | awk -F'=' '/^PATH/ {print $2}')
        # In ra biến $PATH của người dùng
        echo -e "${CYAN}[*]Binary info: $path${NC}"

        binary_list=$(echo "$crontab_content" | awk '!/^#/ && !/PATH=/ {print $6}' | sort -u)

        for binary in $binary_list; do
            binary_paths=$(which -a $binary 2>/dev/null)
            if [ -n "$binary_paths" ]; then
                while IFS= read -r binary_path; do
                    permissions=$(stat -c '%A' "$binary_path")
                    binary_info="\e[32m[+] Binary: $binary | Path: $binary_path | Permissions: $permissions\e[0m"
                    
                    # Kiểm tra quyền ghi ở nhóm người dùng và người dùng khác
                    #if [[ $permissions == *g*w* || $permissions == *o*w* ]]; then
                    if [[ $permissions =~ ....w..w. ]]; then
                        binary_info="\e[33;1m[!]Binary: $binary | Path: $binary_path | ${RED}Permissions: $permissions\e[0m"
                    fi
                    
                    echo -e -n "$binary_info\n"
                done <<< "$binary_paths"
            fi
        done
    fi
done

