#!/bin/bash

phfile=$1

#directory for all temp files
rm -r -f FOO
mkdir FOO

#run pint-clingo to get new files
~/Documents/pint-2013-09-23/bin/pint test1.ml $phfile > FOO/pintout.lp
 clingo --verbose=0 0 FOO/pintout.lp phinfercoop.lp > FOO/results.txt
rfile=FOO/results.txt

#dump to unformatted version
phc -l dump < $phfile >FOO/output_dump.txt

#store stop time and initial conditions
stop_time=$(awk '($1=="directive" && $2=="sample"){print $3}' $phfile)
init_cond=$(awk '($1=="initial_state"){print $0}' $phfile | awk '{$1="";print;}'|sed 's/,//g')
echo $stop_time  >> FOO/initial_final.txt
echo $init_cond >> FOO/initial_final.txt

awk '($1!="initial_state"){print $0}' FOO/output_dump.txt > FOO/output_dump2.txt
dfile=FOO/output_dump2.txt

#store process names
awk '{for (i=1; i<=NF; i++) if($i=="process"){print $(i+1)}}' $phfile >FOO/processes.txt
awk '{for (i=1; i<=NF; i++) if($i=="process"){print $(i+1) " " $(i+2)}}' $phfile >FOO/sorts_size.txt

#store cooperative sort names
awk '{for (i=1; i<=NF; i++) if($i=="process"){print $(i+1)}}' $dfile > FOO/fulllist.txt
grep -Fxvf FOO/processes.txt FOO/fulllist.txt > FOO/coop_names.txt


# switch out variables (up to 3)
while read line; do #for every line in the dumped file
var=$(echo $line | awk '{print $1}')
var_no=$(echo $line | awk '{print $2}')
target=$(echo $line | awk '{print $4}')

if [ "$var" != "process" ] && ! grep -qx "$target" FOO/coop_names.txt ; then

#if var is a cooperative sort, start searching in files
if grep -qx "$var" FOO/coop_names.txt; then

./autocode.sh $var $var_no $rfile
replace=$(awk '{print}' ORS=' ' FOO/temp.txt)

line2=$(echo $line|cut -d " " -f 3-10)
line2=$(echo $replace $line2)
echo $line2 >> FOO/importfile.txt
rm FOO/temp.txt
#else, move on
else

echo $line >> FOO/importfile.txt
fi
fi
done < $dfile



