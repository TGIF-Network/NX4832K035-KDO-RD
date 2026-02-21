#!/bin/bash
#################################################
#  Get Last 8 Heard Last from MMDVMHost Log     #
#                                               #
#  VE3RD                        2020-05-03      #
#################################################

set -o errexit
set -o pipefail

p="$1"
[ -z "$p" ] && p=0

####################################################
function domode2
{
    output=()

    while read -r line
    do
        mode=$(echo "$line" | cut -d' ' -f4 | tr -d ',')
        call=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}')
        [ -z "$call" ] && continue

        tm=$(echo "$line" | cut -d' ' -f3)
        dt=$(echo "$line" | cut -d' ' -f2)
        dtm="$dt $tm"

        dataline=$(grep -m1 "^.*,${call}," /usr/local/etc/stripped2.csv 2>/dev/null)

        name="NoName"
        prov="NA"
        cntry=""

        if [ -n "$dataline" ]; then
            name=$(echo "$dataline" | cut -d',' -f3)
            prov=$(echo "$dataline" | cut -d',' -f6)
            cntry=$(echo "$dataline" | cut -d',' -f7 | tr -d '\r')
            [ -z "$prov" ] && prov="NA"
        fi

        dtm2=$(date -d "${dtm} UTC" '+%H:%M:%S')

        if [ "$mode" = "YSF" ]; then
            output+=("$dtm2 $mode $call")
        fi

        if [ "$mode" = "DMR" ]; then
            output+=("$dtm2 $mode $call $name $prov $cntry")
        fi

    done <<< "$list1"

    printf "%s|" "${output[@]}"
    echo
}

######################################
# Start of Main Program
######################################

# 1️⃣ Get newest Pi-Star log
latest=$(ls -t /var/log/pi-star/MM* 2>/dev/null | head -n1)

if [[ -z "$latest" ]]; then
    echo "No Pi-Star log files found."
    exit 1
fi

# 2️⃣ Get recent activity lines
list2=$(tail -n 200 "$latest" 2>/dev/null | \
grep -iE 'voice transmission from|received network data from')

# 3️⃣ Sort newest first
list3=$(echo "$list2" | sort -k2,3r)

# 4️⃣ Remove older duplicates (newest kept)
list4=$(echo "$list3" | awk '
{
    if ($0 ~ /from [^ ]+/) {
        split($0, a, "from ")
        split(a[2], b, " ")
        callsign = b[1]
        if (callsign && !seen[callsign]++) print
    }
}')

# 5️⃣ Keep newest 16 unique calls
list5=$(echo "$list4" | head -n 16)

# 6️⃣ Load into array
mapfile -t arr <<< "$list5"

group_size=4
start=$(( p * group_size ))
end=$(( start + group_size - 1 ))

if (( start >= ${#arr[@]} )); then
    echo "Requested group $p is out of range."
    exit 1
fi

(( end >= ${#arr[@]} )) && end=$(( ${#arr[@]} - 1 ))

count=$(( end - start + 1 ))
list1=$(printf "%s\n" "${arr[@]:start:count}")

domode2
