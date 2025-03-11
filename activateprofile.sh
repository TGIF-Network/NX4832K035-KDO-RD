#!/bin/bash
############################################################
#  Activate  Profile                                       #
#  VE3RD                                      2019/11/18   #
############################################################
set -o errexit
set -o pipefail


set -o errexit
set -o pipefail
ver="20250204"
dirn=/etc/profiles.ini
declare -i pnum

if [ -z "$1" ]; then
        exit
fi

	pnum=$(echo $1 | sed 's/^0*//')
	#pnum="$1"
        echo "$pnum"
        m0=$(sed -nr "/^\[Profile $pnum\]/ { :l /^Name[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m1=$(sed -nr "/^\[Profile $pnum\]/ { :l /^RXOffset[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m2=$(sed -nr "/^\[Profile $pnum\]/ { :l /^TXOffset[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m3=$(sed -nr "/^\[Profile $pnum\]/ { :l /^RXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m4=$(sed -nr "/^\[Profile $pnum\]/ { :l /^TXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m5=$(sed -nr "/^\[Profile $pnum\]/ { :l /^Callsign[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m6=$(sed -nr "/^\[Profile $pnum\]/ { :l /^Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m7=$(sed -nr "/^\[Profile $pnum\]/ { :l /^StartupDstId[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m8=$(sed -nr "/^\[Profile $pnum\]/ { :l /^Address[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m9=$(sed -nr "/^\[Profile $pnum\]/ { :l /^Mode[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m10=$(sed -nr "/^\[Profile $pnum\]/ { :l /^Port[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
        m11=$(sed -nr "/^\[Profile $pnum\]/ { :l /^Password[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)


sudo mount -o remount,rw /

                sudo sed -i '/^\[/h;G;/Modem/s/\(^RXOffset=\).*/\1'"$m1"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/Modem/s/\(^TXOffset=\).*/\1'"$m2"'/m;P;d' /etc/mmdvmhost

                sudo sed -i '/^\[/h;G;/Info/s/\(^RXFrequency=\).*/\1'"$m3"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/Info/s/\(^TXFrequency=\).*/\1'"$m4"'/m;P;d' /etc/mmdvmhost

                sudo sed -i '/^\[/h;G;/General/s/\(^Callsign=\).*/\1'"$m5"'/m;P;d' /etc/mmdvmhost
m6a=${m6:0:7}

                sudo sed -i '/^\[/h;G;/General/s/\(^Id=\).*/\1'"$m6a"'/m;P;d' /etc/mmdvmhost

if [ "$m9" == "DMR" ]; then
                sudo sed -i '/^\[/h;G;/DMR/s/\(^Enable=\).*/\11/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR Network/s/\(^Enable=\).*/\11/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR Network/s/\(^Port=\).*/\1'"$m10"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR Network/s/\(^RemotePort=\).*/\1'"$m10"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR Network/s/\(^LocalPort=\).*/\1'"$m10"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR Network/s/\(^Address=\).*/\1'"$m8"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR/s/\(^Id=\).*/\1'"$m6"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR Network/s/\(^Password=\).*/\1'"$m11"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/DMR/s/\(^Id=\).*/\1'"$m6"'/m;P;d' /etc/mmdvmhost
echo "Id=$m6"
		if [ "$m8" == "127.0.0.1" ]; then
			sudo sed -i '/^\[/h;G;/DMR Network/s/\(^Type=\).*/\1Gateway/m;P;d' /etc/mmdvmhost
			echo "Type=Gateway"
		else	
			sudo sed -i '/^\[/h;G;/DMR Network/s/\(^Type=\).*/\1Direct/m;P;d' /etc/mmdvmhost
			echo "Type=Direct"
		fi
fi

                sudo sed -i '/^\[/h;G;/NXDN/s/\(^Enable=\).*/\1'"$m9"'/m;P;d' /etc/mmdvmhost
                sudo sed -i '/^\[/h;G;/NXDN Network/s/\(^Enable=\).*/\1'"$m10"'/m;P;d' /etc/mmdvmhost


	## Get specialty Passwords	
	if [[ "$pval" = "PRIMEPW" ]]; then
		 pval=$(sudo sed -n '/'"prime"'/p' /usr/local/etc/DMR_Hosts.txt | sed -E "s/[[:space:]]+/|/g"  | cut -d'|' -f4)
	fi

	if [[ "$pval" = "MNETPW" ]]; then
		 pval=$(sudo sed -n '/'"mnet"'/p' /usr/local/etc/DMR_Hosts.txt | sed -E "s/[[:space:]]+/|/g"  | cut -d'|' -f4)
	fi

	if [[ "$pval" = "BMPW" ]]; then
		pval=$(sudo grep Password  /etc/dstar-radio.mmdvmhost | cut -d'=' -f2)
	fi

	if [[ "$pval" = "TGIF" ]]; then
		pval=$(sudo grep Password  /etc/dstar-radio.mmdvmhost | cut -d'=' -f2)
	fi

	if [[ "$pval" = "MNET" ]]; then
		pval=$(sudo grep Password  /etc/dstar-radio.mmdvmhost | cut -d'=' -f2)
	fi


	
	#sudo mmdvmhost.service restart


 sudo mmdvmhost.service restart
sudo mount -o remount,ro /

exit


if [ "$m9" == "D-Star" ]; then


fi

if [ "$m9" == "DMR" ]; then


fi

if [ "$m9" == "DMRG" ]; then


fi

if [ "$m9" == "YSF" ]; then


fi

if [ "$m9" == "NXDN" ]; then


fi

if [ "$m9" == "P25" ]; then


fi

if [ "$m9" == "M17" ]; then


fi

if [ "$m9" == "YSF2DMR" ]; then


fi

if [ "$m9" == "YSF2NXDN" ]; then


fi

if [ "$m9" == "YSF2P25" ]; then


fi

if [ "$m9" == "DMR2YSF" ]; then


fi

if [ "$m9" == "DMR2YSF-G" ]; then


fi

if [ "$m9" == "DMR2NXDN" ]; then


fi

if [ "$m9" == "DMR2NXDN-G" ]; then


fi




