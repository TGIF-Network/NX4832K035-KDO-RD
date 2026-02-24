#!/bin/bash
####################################################################
#  Rest pi-star password raspberry not acceptable                  #
#                                                                  #
#  VE3RD                                             2025-04-02    #
####################################################################
set -o errexit
set -o pipefail

sudo mount -o remount,rw /

# Function to decode a Base64 string
decode_string() {
    local input="$1"
    echo -n "$input" | base64 -d
}

encrypted=$(cat /etc/pspass)
if [ -z "$encrypted" ]; then

 echo "No Password File Found"
 exit
fi

decrypted=$(decode_string "$encrypted")
#if [ "$decrypted" == "raspberry" ]; then
#	echo "Sorry: PW= raspbery not Accepted\rPlease select another password"
#	exit
#fi

echo "Pi-star Password is now $decrypted"


sudo chpasswd <<< "pi-star:$decrypted"
