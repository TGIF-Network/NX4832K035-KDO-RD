#!/bin/bash
############################################################
#  Get  All Mode from /etc/mmdvmhost                       #
#  $1 1-6 Select Mode to get status of                     #
#                                                          #
#  Returns the status Enable=0 or 1                        #
#                                                          #
#  KF6S                                        09-01-2019  #
############################################################
set -o errexit
set -o pipefail

 m1=$(sed -n '/^[ \t]*\[DMR\]/,/\[/s/^[ \Enable[ \t]*=[ \t]*//p' /etc/mmdvmhost)
 m2=$(sed -n '/^[ \t]*\[D-Star\]/,/\[/s/^[ \Enable[ \t]*=[ \t]*//p' /etc/mmdvmhost)
 m3=$(sed -n '/^[ \t]*\[System Fusion\]/,/\[/s/^[ \Enable[ \t]*=[ \t]*//p' /etc/mmdvmhost)
 m4=$(sed -n '/^[ \t]*\[P25\]/,/\[/s/^[ \Enable[ \t]*=[ \t]*//p' /etc/mmdvmhost)
 m5=$(sed -n '/^[ \t]*\[NXDN\]/,/\[/s/^[ \Enable[ \t]*=[ \t]*//p' /etc/mmdvmhost)
 m6=$(sed -n '/^[ \t]*\[POCSAG\]/,/\[/s/^[ \Enable[ \t]*=[ \t]*//p' /etc/mmdvmhost)
 m7=$(sed -n '/^[ \t]*\[M17\]/,/\[/s/^[ \Enable[ \t]*=[ \t]*//p' /etc/mmdvmhost)

echo "$m1|$m2|$m3|$m4|$m5|$m6|$m7"
