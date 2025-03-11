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
while read -r line
do
	mode=$(echo "$line"| cut -d ' ' -f 4 | tr -d ',')

if [ "$mode" == "DMR" ]; then
	call=$(echo "$line" | cut -d' ' -f14)
fi
if [ "$mode" == "D-Star" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
fi
if [ "$mode" == "P25" ]; then
	call=$(echo "$line" | cut -d' ' -f9)
fi
if [ "$mode" == "NXDN" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
fi
if [ "$mode" == "M17" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
fi
if [ "$mode" == "YSF" ]; then
	call=$(echo "$line" | cut -d' ' -f11)
	if [ "$call" == "" ]; then
		call=$(echo "$line" | cut -d' ' -f16)
	fi
fi
	tm=$(echo "$line" | cut -d' ' -f3)
	dt=$(echo "$line" | cut -d' ' -f2)
	
	tm1=$(date -d "${tm:0:-1} UTC" '+%R')
	tm=${tm1:0:5}
#	dt=${dt:5:5}
	pl=$(echo "$line" | cut -d' ' -f20)
	dur=$(echo "$line" | cut -d' ' -f18)
	tg=$(echo "$line" | cut -d' ' -f17)

#	echo "Add Call: $call" >> /home/pi-star/lh2_start.txt
	dataline=$(sudo sed -n "/$call/p" /usr/local/etc/stripped2.csv)
       	did=$(echo "$dataline" | cut -d',' -f1 | head -1)
        call1=$(echo "$dataline" | cut -d',' -f2 | head -1)

        name=$(echo "$dataline" | cut -d',' -f3 | head -1)
        city=$(echo "$dataline" | cut -d',' -f4 | head -1)
        prov=$(echo "$dataline" | cut -d',' -f5 | head -1)
        country=$(echo "$dataline" | cut -d',' -f7 | head -1)

	if [ -z "$name" ]; then
		name="Name N/A"
	fi


#	line3=$(echo  "$dt" "$tm" "$call" "$name" | awk '{printf  "%5s %s %s %s|\n", $1 $2 $3 $name}')
	line3=""
	echo  "$tm $mode $call $name $country |" |  tr -d "\n"
#	echo "$line2"
#	line4=${line3:0:37}
	line6=$(echo "$line3" | tr -d "\n")

	list5+="$line6"
done <<< "$list1"

var="${list5:0:400}"
#echo "${var}"
#sudo mount -o remount,rw /

#echo "${var}" >> ./lh2_start.txt

}


######################################
#Start of Main Program
######################################

f1=$(ls -tr /var/log/pi-star/MMDVM* | tail -1)
#list1=$(sudo sed -n '/received network end of voice transmission from/p' $f1 | tail -n 50 | sort -r -k15 -u |tail -n8)
list1=$(cat /var/log/pi-star/MMDVM* | grep "end of transmission from" | tail -16 | sort -u -k15 | sort -k3 | tail -n20)
#echo "5 $list1"
#echo "  "
line=$(echo "$list1" | tail -n8)
#echo "6 $list1"
	domode2

#sudo mount -o remount,ro /
exit






#list3=$(echo "$list1" | awk '$14!=savestr {print substr($2,6,5),substr($3,0,6),$14,$17,$6,$18,$20; savestr=$14}' | sort -u -r -k1,2 | tail -8)
#echo "$list3"

#list3=$(echo "$list1" | awk '$14!=savestr {print substr($2,6,5),substr($3,0,6),$14,$17,$6,$18,$20; savestr=$14}' | sort -u -r -k2,2 | tail -8)
#echo "$list3"
#list4=$(echo "$list3" | sort -u -k2)
#echo  "4 - $list4"
#lcnt=$(echo "$list3" | wc -l)
#if [ $lcnt -lt 20 ]; then
#	list3+=$list4
#fi
#  echo "Test1234 | Test 2345 | TestTest\r |12345678"

#echo "$list3"

#echo "$list3" | sed -n '1,8p;9q' |  awk '{printf "%5s %5s %7s %6s %1s %4s %-4s|\n", $1, $2, $3, $4, $5, $6, $7}' | tr -d "\n | tail -8"
#list9=$(echo "$list1" | sed -n '1,6p;7q' | awk '{print $1, $2, $3, $4}' )

