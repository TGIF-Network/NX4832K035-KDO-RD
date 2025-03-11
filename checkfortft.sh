#!/bin/bash
############################################################
#  Get Profile Data From Pi-star                           #
#  Returns a multi string | Separated                      #
#                                                          #
#                                                          #
#  VE3RD                                     2019-11-17    #
############################################################
set -o errexit
set -o pipefail
#Sun  9 Feb 10:13:59 EST 2025

 FILE=/usr/local/etc/NX4832K035.tft
#F1=$(date -r  /usr/local/etc/NX4832K035.tft | sed 's/ /-/g')
F1=$(date -r  /usr/local/etc/NX4832K035.tft | tr '  ' ' ')
#m4=$(cat /proc/meminfo |head -3 |head -1 | tr -d ' ')

#echo "$F1"
#dt0=$(date -r /usr/local/etc/NX4832K035.tft | cut -d " " -f2)
#dt1=$(date -r /usr/local/etc/NX4832K035.tft | cut -d " " -f3)
#dt2=$(date -r /usr/local/etc/NX4832K035.tft | cut -d " " -f4)
#dt3=$(date -r /usr/local/etc/NX4832K035.tft | cut -d " " -f7)
dt4=$(date -r /usr/local/etc/NX4832K035.tft | cut -d " " -f5)
#dt="$dt3 $dt2  $dt1"

dtt=$(stat /usr/local/etc/NX4832K035.tft | grep Birth | cut -d '.' -f1 | cut -d ' ' -f3,4)
#echo "$dtt"

 if [ ! -f "$FILE" ]; then
        # Copy failed
      echo "No TFT File Available to Flash - Try Again"
  else
#   echo "NX4832K035.tft \r$dt1 $dt2 $dt3"
#   echo "NX4832K035.tft File Found!\r$dt0 $dt1 $dt2 $dt3$dt4"
   echo "NX4832K035.tft File Found!\r $dtt"
#   echo "NX4832K035.tft File Found!\r $dt4"

 fi

