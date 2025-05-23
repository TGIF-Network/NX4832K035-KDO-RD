#!/bin/bash
#################################################
#  Get Last Heard Liost from MMDVMHost Log	#
#						#
#						#
#  VE3RD 			2025-03-11	#
#################################################
set -o errexit
set -o pipefail
sudo mount -o remount,rw /

#if [ -f /home/pi-star/lh2_start.txt ]; then
#  rm /home/pi-star/lh2_start.txt
#fi
#if [ -f /home/pi-star/lhlog.txt ]; then
#  rm /home/pi-star/lhlog.txt
#fi

echo "Args = $@" >> /home/pi-star/lh2_start.txt

name=""
pl=""

declare -i n
##########################################################
function getcall
{
line3=""
        mode=$(echo "$list1"| cut -d ' ' -f 4 | tr -d ',')

if [ "$mode" == "DMR" ]; then
        call=$(echo "$list1" | cut -d' ' -f14)
fi
if [ "$mode" == "D-Star" ]; then
        call=$(echo "$list1" | cut -d' ' -f11)
fi
if [ "$mode" == "P25" ]; then
        call=$(echo "$list1" | cut -d' ' -f9)
fi
if [ "$mode" == "NXDN" ]; then
        call=$(echo "$list1" | cut -d' ' -f11)
fi
if [ "$mode" == "M17" ]; then
        call=$(echo "$list1" | cut -d' ' -f11)
fi
if [ "$mode" == "YSF" ]; then
        call=$(echo "$list1" | cut -d' ' -f11)
fi

}

function domode3
{

	echo "Add Call: $call" >> /home/pi-star/lh2_start.txt
	dataline=$(sudo sed -n "/$call/p" /usr/local/etc/stripped.csv)
       	did=$(echo "$dataline" | cut -d',' -f1 | head -1)
        n1=$(echo "$dataline" | cut -d',' -f3 | head -1)
        n2=$(echo "$dataline" | cut -d',' -f4 | head -1)
        city=$(echo "$dataline" | cut -d',' -f5 | head -1)
        prov=$(echo "$dataline" | cut -d',' -f6 | head -1)
        country=$(echo "$dataline" | cut -d',' -f7 | head -1)
      name="$n1 $n2"

if [ -z "$city" ]; then
	city="N/A"
fi
	echo "$dt|$tm|$mode|$call|$name|$city, $prov, $country|$tg|$pl|$dur" 
#| tr -d "\n" 
}

function GetDetail
{
#echo "$list1"
dt=$(echo "$list1" | cut -d " " -f2)
tm1=$(echo "$list1" | cut -d " " -f3)
#echo "$list1"
#echo "$tm1"

tm=$(date -d "${tm1:0:-1} UTC" '+%R')

#echo "$list1"

tm="${tm:0:8}"
#echo "$tm"
mode=$(echo "$list1" | cut -d " " -f4)
call=$(echo "$list1" | cut -d " " -f14)
tg=$(echo "$list1" | cut -d " " -f17)
pl=$(echo "$list1" | cut -d " " -f20)
dur=$(echo "$list1" | cut -d " " -f18)
#echo "$dt :: $tm :: $mode :: $call"

}
##################################################

######################################
#Start of Main Program
######################################


if [ -z "$1" ]; then
	getcall
	f1=$(ls -tr /var/log/pi-star/MMDVM* | tail -1)
	list1=$(sudo sed -n '/transmission from/p' $f1 | sed 's/,//g' | tail -1)
	GetDetail
else
	call="$1"
	f1=$(ls -tr /var/log/pi-star/MMDVM* | tail -1)
	list1=$(sudo sed -n '/'"$1"'/p' $f1 | sed 's/,//g' | tail -1)

#	echo "$list1"
	GetDetail
fi
#echo "$call"


	domode3

sudo mount -o remount,ro /
