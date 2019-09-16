#!/bin/bash
BASEURLHEADER="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/include/linux/"
FILEGE41="security"
FILELE41="lsm_hooks"
BASEURLFOOTER=".h?h=v"

echo $1| grep -E "^((?!([345]\.[0-9]{1,2})).)*$" && echo "arg1 must be kernel version" && exit
echo $2| grep -E "^((?!([345]\.[0-9]{1,2})).)*$" && echo "arg2 must be kernel version" && exit

kompare -v &>/dev/null && CVIEW=$(which kompare)
diffuse -v &>/dev/null && CVIEW=$(which diffuse)

[ $(( $(echo $1 | sed -e 's/\.//') >= 41 )) -eq "1" ] && FILE="$FILELE41" || FILE="$FILEGE41"
URL1=${BASEURLHEADER}${FILE}${BASEURLFOOTER}${1}

[ $(( $(echo $2 | sed -e 's/\.//') >= 41 )) -eq "1" ] && FILE="$FILELE41" || FILE="$FILEGE41"
URL2=${BASEURLHEADER}${FILE}${BASEURLFOOTER}${2}
#echo "URL1: $URL1" #uncomment for debug purpose
#echo "URL2: $URL2" #uncomment for debug purpose


wget -O - -q "$URL1" | tr -d "\n"| sed -e 's/\tvoid (/\nvoid (/g' -e 's/\tint (/\nint (/g'|sed  -e 's/;.*//'| sed -r 's/[\t ]{2,20}/ /g'| egrep "^int|^void"| sed -r 's/^[ \t]*([^\)]*) \(\*([^\)]*)\).*\((.*)\).*/\1|\2|\3/' >/tmp/k${1}.txt
wget -O - -q "$URL2" | tr -d "\n"| sed -e 's/\tvoid (/\nvoid (/g' -e 's/\tint (/\nint (/g'|sed  -e 's/;.*//'| sed -r 's/[\t ]{2,20}/ /g'| egrep "^int|^void"| sed -r 's/^[ \t]*([^\)]*) \(\*([^\)]*)\).*\((.*)\).*/\1|\2|\3/' >/tmp/k${2}.txt

$CVIEW /tmp/k${1}.txt /tmp/k${2}.txt &>/dev/null &
