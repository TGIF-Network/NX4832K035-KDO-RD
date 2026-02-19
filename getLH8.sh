#!/bin/bash
#################################################
#  Get Last 8 Heard Last from MMDVMHost Log	#
#						#
#						#
#  VE3RD 			2020-05-03	#
#################################################
set -o errexit
set -o pipefail

p="$1"

if [ -z "$1" ]; then
  p=0
fi

lin=""
name=""

declare -i n
####################################################
function domode2
{
line3=""
call1=""
name=""
#line=list1
#echo "$line"
line3=""
line0=""
line7=""

while read -r line
do
	mode=$(echo "$line"| cut -d ' ' -f 4 | tr -d ',')
	call=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}')

#    echo "ReadLine $mode $call"

#if [ "$mode" = "DMR" ]; then
#	call=$(echo "$line" | cut -d' ' -f14)
#fi
#if [ "$mode" = "D-Star" ]; then
#	call=$(echo "$line" | cut -d' ' -f11)
#fi
#if [ "$mode" = "P25" ]; then
#	call=$(echo "$line" | cut -d' ' -f9)
#fi
#if [ "$mode" = "NXDN" ]; then
#	call=$(echo "$line" | cut -d' ' -f11)
#fi
#if [ "$mode" = "M17" ]; then
#	call=$(echo "$line" | cut -d' ' -f11)
#fi
#if [ "$mode" = "YSF" ]; then
#	call=$(echo "$line" | cut -d' ' -f11)
#	if [ "$call" = "" ]; then
#		call=$(echo "$line" | cut -d' ' -f16)
#		call=$(echo "$line" | cut -d' ' -f9)
#	fi
#fi
#M: 2026-02-18 22:28:26.989 YSF, received network data from N4HYS      to DG-ID 0 at N4HYS

	tm=$(echo "$line" | cut -d' ' -f3)
	dt=$(echo "$line" | cut -d' ' -f2)
	dtm="$dt ""$tm"
	
#	tm1=$(date -d "${tm:0:-1} UTC" '+%R')
#	tm=${tm1:0:5}
#	loc=$(dt -d "${input:0} UTC" '+%Y-%m-%d %H:%M:%S')
#	dt=${dt:5:5}
	pl=$(echo "$line" | cut -d' ' -f20)
	dur=$(echo "$line" | cut -d' ' -f18)
	tg=$(echo "$line" | cut -d' ' -f17)

#	echo "Add Call: $call" >> /home/pi-star/lh2_start.txt
#	dataline=$(sudo sed -n "/$call/p" /usr/local/etc/stripped2.csv)
	dataline=$(grep -m1 "$call" /usr/local/etc/stripped2.csv 2>/dev/null)
city=""
name="NoName"
prov=""
country=""

if [ ! -z "$dataline" ]; then
#echo "$dataline"
       	did=$(echo "$dataline" | cut -d',' -f1 | head -1)
        call1=$(echo "$dataline" | cut -d',' -f2 | head -1)

        name=$(echo "$dataline" | cut -d',' -f3 | head -1)
        city=$(echo "$dataline" | cut -d',' -f5 | head -1)
        prov=$(echo "$dataline" | cut -d',' -f6 | head -1)
        cntry=$(echo "$dataline" | cut -d',' -f7 | head -1 | tr -d '\r')

       if [ -z "$prov" ]; then
		prov="NA"
      fi

#	echo "$call $cntry"

fi
  	dtm2=$(date -d "${dtm:0} UTC" '+%H:%M:%S')


      if [ "$mode" = "YSF" ]; then
	line10="$dtm2","$mode,""$call|"
#	line7+="$line0|"
      fi 
      if [ "$mode" = "DMR" ]; then
	line11="$dtm2 $mode $call $name $prov $cntry|"
#       line1+=" $cntry"

#	line8+="$line1|"
        
      fi
	
line9+="$line10"
line9+="$line11"

done <<< "$list1"

echo -e "$line9"


}


######################################
#Start of Main Program
######################################


list1=""


# 1️⃣ Get newest Pi-Star log
latest=$(ls -t /var/log/pi-star/MM* 2>/dev/null | head -n1)
if [[ -z "$latest" ]]; then
    echo "No Pi-Star log files found."
    exit 1
fi

# 2️⃣ Extract last 200 lines, filter, deduplicate by callsign
list2=$(tail -n 100 "$latest" 2>/dev/null | grep -iE 'voice transmission from|received network data from' 

#        awk '{
#            if ($0 ~ /from [^ ]+/) {
#                split($0, a, "from ")
#                split(a[2], b, " ")
#                callsign = b[1]
#                if (callsign && !seen[callsign]++) print $0
#            }
#        }'
)
#echo "$list2"
# 3️⃣ Sort newest first by date/time (columns 2+3), pick 16 newest lines
list3=$(echo "$list2" | sort -k2,3r | head -n 16)


# 4️⃣ Load into array (arr[0] = newest)
mapfile -t arr <<< "$list3"

# 5️⃣ Calculate start index for the requested group
group_size=4
group_num="$p"
start=$(( group_num * group_size ))
end=$(( start + group_size - 1 ))

#echo "$start - $end"
#echo  ${#arr[@]}
if (( start >= ${#arr[@]} )); then
    echo "Requested group $group_num is out of range."
    exit 1
fi

# Adjust end if fewer than 4 lines remain
(( end >= ${#arr[@]} )) && end=$(( ${#arr[@]} - 1 ))

# 6️⃣ Extract the group
count=$(( end - start + 1 ))
list1=$(printf "%s\r\n" "${arr[@]:start:count}")
#echo -e "List1 - $list1"


domode2

#sudo mount -o remount,ro /



#echo "Input UTC Taken from last entry in MMDVMHost Log file"
#echo "Input $input"
#loc=$(date -d "${input:0} UTC" '+%Y-%m-%d %H:%M:%S')
#echo "Local $loc"
#echo "  convert back to UTC "
#utc2=$(date -d "${loc:0}" +%s | xargs -I {} date -u -d "@{}" '+%Y-%m-%d %H:%M:%S')
#echo "UTC $utc2" 
