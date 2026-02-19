#!/bin/bash
#################################################
#  Get Last 8 Heard Last from MMDVMHost Log	#
#						#
#						#
#  VE3RD 			2020-05-03	#
#################################################
set -o errexit
set -o pipefail

#if [ -f /home/pi-star/lh2_start.txt ]; then
#  rm /home/pi-star/lh2_start.txt
#fi
#if [ -f /home/pi-star/lhlog.txt ]; then
#  rm /home/pi-star/lhlog.txt
#fi

#echo "Args = $@" >> /home/pi-star/lh2_start.txt

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
if [ "$mode" = "DMR" ]; then
	call=$(echo "$line" | cut -d' ' -f14)
fi
if [ "$mode" = "D-Star" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
fi
if [ "$mode" = "P25" ]; then
	call=$(echo "$line" | cut -d' ' -f9)
fi
if [ "$mode" = "NXDN" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
fi
if [ "$mode" = "M17" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
fi
if [ "$mode" = "YSF" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
	if [ "$call" = "" ]; then
#		call=$(echo "$line" | cut -d' ' -f16)
		call=$(echo "$line" | cut -d' ' -f9)
	fi
fi
#M: 2026-02-18 22:28:26.989 YSF, received network data from N4HYS      to DG-ID 0 at N4HYS

	tm=$(echo "$line" | cut -d' ' -f3)
	dt=$(echo "$line" | cut -d' ' -f2)
	dtm="$dt ""$tm"
	
	tm1=$(date -d "${tm:0:-1} UTC" '+%R')
	tm=${tm1:0:5}
#	loc=$(dt -d "${input:0} UTC" '+%Y-%m-%d %H:%M:%S')
#	dt=${dt:5:5}
	pl=$(echo "$line" | cut -d' ' -f20)
	dur=$(echo "$line" | cut -d' ' -f18)
	tg=$(echo "$line" | cut -d' ' -f17)

#	echo "Add Call: $call" >> /home/pi-star/lh2_start.txt
	dataline=$(sudo sed -n "/$call/p" /usr/local/etc/stripped2.csv)

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

#	echo "$call $cntry"

fi
  	dtm2=$(date -d "${dtm:0} UTC" '+%H:%M:%S')


      if [ "$mode" = "YSF" ]; then
	line0="$dtm2","$mode,""$call|"
#	line7+="$line0|"
      fi 
      if [ "$mode" = "DMR" ]; then
	line1="$dtm2 $mode $call $name $cntry|"
#       line1+=" $cntry"

#	line8+="$line1|"
        
      fi
	
line9+="$line0"
line9+="$line1"

#	line3=$(echo  "$dt" "$tm" "$call" "$name" | awk '{printf  "%5s %s %s %s|\n", $1 $2 $3 $name}')
#	line3=""
#	echo  "$tm $mode $call $name $cntry |" |   tr -d "\n"
#	echo "$line2"
#	line4=${line3:0:37}
	line6=$(echo "$line3" | tr -d "\n")

	list5+="$line6"
done <<< "$list1"

echo -e "$line9"

#echo -e "$line7"
#echo -e "$line8"

#echo -e "\r\n"
#echo -e "$line7"
var="${list5:0:400}"
#echo "${var}"
#sudo mount -o remount,rw /

#echo "${var}" >> ./lh2_start.txt

}


######################################
#Start of Main Program
######################################

f1=$(ls -tr /var/log/pi-star/MMDVM* | tail -1)
#list1=$(tail -n 100 /var/log/pi-star/MM* | grep 'transmission from' |  awk '!seen[$14]++' | sort -k3n)
#list2=$(tail -n 100 /var/log/pi-star/MM* | grep 'transmission from' |  awk '{seen[$14]=$0} END {for (key in seen) print seen[key]}' | sort -k3n)
#list2=$(tail -n 200 /var/log/pi-star/MM* | grep 'transmission from' |  awk '{seen[$14]=$0} END {for (key in seen) print seen[key]}')
list2=$(tail -n 200 /var/log/pi-star/MM* 2>/dev/null |
        grep -E 'voice transmission from|received network data from' |
        awk '!seen[$14]++ {print $0}' )

#echo "$list2"

list3=$(echo "$list2" | sort -k2 -k3,1nr | tail -n 20)
list1=$(echo "$list3" | tail -n 8)


#echo "5 $list1"
#echo "  "
line=$(echo "$list1" | tail -n10)
#echo "6 $list1"
	domode2

#sudo mount -o remount,ro /



#echo "Input UTC Taken from last entry in MMDVMHost Log file"
#echo "Input $input"
#loc=$(date -d "${input:0} UTC" '+%Y-%m-%d %H:%M:%S')
#echo "Local $loc"
#echo "  convert back to UTC "
#utc2=$(date -d "${loc:0}" +%s | xargs -I {} date -u -d "@{}" '+%Y-%m-%d %H:%M:%S')
#echo "UTC $utc2" 
