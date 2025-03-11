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
#dirn=/usr/local/etc/Nextion_Support/profiles.txt
dirn=/etc/mmdvmhost

		m1=$(sed -nr "/^\[NextionDriver\]/ { :l /^LogLevel[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
		m2=$(sed -nr "/^\[NextionDriver\]/ { :l /^WaitForLan[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
		m3=$(sed -nr "/^\[NextionDriver\]/ { :l /^SleepWhenInactive[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
		m4=$(sed -nr "/^\[NextionDriver\]/ { :l /^RemoveDim[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
		m5=$(sed -nr "/^\[Nextion\]/ { :l /^Brightness[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)
		m6=$(sed -nr "/^\[Nextion\]/ { :l /^IdleBrightness[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $dirn)


               	mt="$m1|$m2|$m3|$m4|$m5|$m6"
		echo "$mt"

