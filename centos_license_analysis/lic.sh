#!/bin/bash

#MIT=
#Python
#BSD
#ISC
#LGPLv2
#MPLv2.0

function getDefaultLic(){
pkg="$1"
liclist=`rpm -qa --qf '%{license}\n' $pkg| awk -F'and|or|\\\(|\\\)' '{ if(NF == 1) print $0; else { for (i = 1; i <= NF; i++) print $i} }' | sed -e 's/^\s*//' -e 's/\s*$//g'`
lic=""
for i in "$liclist";
do 
defLic=`grep "^${i}=" map.txt | awk -F'=' '{print $2}'`
lic="${lic}${defLic}";
done
echo "$lic"
}

rpm -qa --qf '%{name}\n'| while read pkg; do lic=`rpm -qa --qf '%{license}' $pkg`; licfile=`rpm -ql $pkg | egrep "COPY|LIC|GPL"`; if [ -z "$licfile" ]; then licfile=$(getDefaultLic $pkg); readme=`rpm -ql $pkg | egrep README`; licfile="${licfile} ${readme}"; ref="REF";fi; echo $pkg,$lic,$licfile,$ref; ref=""; done 
#rpm -qa --qf '%{name}\n'| while read pkg; do lic=`rpm -qa --qf '%{license}' $pkg`; licfile=`rpm -ql $pkg | egrep "COPY|LIC|GPL"`; if [ -z "$licfile" ]; then licfile=`rpm -ql $pkg | egrep README`; fi; if [ -z "$licfile" ]; then licfile=`getDefaultLic $pkg`; fi; echo $pkg,$lic,$licfile; done > lic_map.csv

