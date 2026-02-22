#!/bin/bash
#################################################
#  Get Last 16 Heard from MMDVMHost Log
#  Stable Version for 10-sec Timer Execution
#################################################

p="$1"
[ -z "$p" ] && p=0

###############################################
getysfinfo() {

DATA=$(timeout 6 curl -4 -s \
  --connect-timeout 3 \
  --max-time 5 \
  "https://api.hamdb.org/v1/${call}/json/hamdb")

name=$(echo "$DATA" | tr -d '\n' | sed -n 's/.*"fname":"\([^"]*\)".*/\1/p')
prov=$(echo "$DATA" | tr -d '\n' | sed -n 's/.*"state":"\([^"]*\)".*/\1/p')
cntry=$(echo "$DATA" | tr -d '\n' | sed -n 's/.*"country":"\([^"]*\)".*/\1/p')

[ -z "$name" ] && name="NoName"
[ -z "$prov" ] && prov="NA"

if [ "$cntry" = "United States" ]; then
   cntry="USA"
fi
}
###############################################

###############################################
domode2() {

output=()

while read -r line
do
    mode=$(echo "$line" | awk '{print $4}' | tr -d ',')
    call=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}')
    [ -z "$call" ] && continue

    tm=$(echo "$line" | awk '{print $3}')
    dt=$(echo "$line" | awk '{print $2}')
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

    # If YSF and not found locally, query HamDB
    if [ "$mode" = "YSF" ] && [ "$name" = "NoName" ]; then
        getysfinfo
    fi

    dtm2=$(date -d "${dtm} UTC" '+%H:%M:%S' 2>/dev/null)
    [ -z "$dtm2" ] && dtm2="$tm"

    output+=("$dtm2 $mode $call $name $prov $cntry")

done <<< "$list1"

printf "%s|" "${output[@]}"
echo
}
###############################################

###############################################
# Main Program
###############################################

latest=$(ls -t /var/log/pi-star/MM* 2>/dev/null | head -n1)

[ -z "$latest" ] && exit 0

list2=$(tail -n 200 "$latest" 2>/dev/null | grep -i 'from')
[ -z "$list2" ] && exit 0

# Stable reverse chronological sort
list3=$(echo "$list2" | sort -k2,2r -k3,3r)

# Remove duplicates (keep newest)
list4=$(echo "$list3" | awk '
{
    if ($0 ~ /from [^ ]+/) {
        split($0, a, "from ")
        split(a[2], b, " ")
        callsign = b[1]
        if (callsign && !seen[callsign]++) print
    }
}')

# Keep newest 16
list5=$(echo "$list4" | head -n 16)

mapfile -t arr <<< "$list5"

# Ensure always 16 entries (prevents blank group 0)
while (( ${#arr[@]} < 16 )); do
    arr+=(" ")
done

group_size=4
start=$(( p * group_size ))
end=$(( start + group_size - 1 ))

(( end >= ${#arr[@]} )) && end=$(( ${#arr[@]} - 1 ))

count=$(( end - start + 1 ))
list1=$(printf "%s\n" "${arr[@]:start:count}")

domode2
