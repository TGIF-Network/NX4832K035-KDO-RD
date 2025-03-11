#!/bin/bash
############################################################
#  Set System Paraams                                      #
#  VE3RD                                      2025-02-10   #
############################################################
set -o errexit
set -o pipefail


set -o errexit
set -o pipefail
ver="20250210"
dirn=/etc/profiles.ini
declare -i pnum

if [ -z "$6" ]; then
        exit
fi
args=("$@")
p0=${args[0]}
p1=${args[1]}
p2=${args[2]}
p3=${args[3]}
p4=${args[4]}
p5=${args[5]}
echo "$p0 $p1 $p2 $p3 $p4 $p5" 
sudo mount -o remount,rw /
                sudo sed -i '/^\[/h;G;/Nextion/s/\(^Brightness=\).*/\1'"$p4"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/Nextion/s/\(^IdleBrightness=\).*/\1'"$p5"'/m;P;d' /etc/mmdvmhost


                sudo sed -i '/^\[/h;G;/NextionDriver/s/\(^LogLevel=\).*/\1'"$p0"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/NextionDriver/s/\(^WaitForLan=\).*/\1'"$p1"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/NextionDriver/s/\(^SleepWhenInactive=\).*/\1'"$p2"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/NextionDriver/s/\(^RemoveDim=\).*/\1'"$p3"'/m;P;d' /etc/mmdvmhost

#systemctl stop mmdvmhost.service
#systemctl stop nextiondriver.service

#sleep 2

#systemctl start mmdvmhost.service
#systemctl start nextiondriver.service

