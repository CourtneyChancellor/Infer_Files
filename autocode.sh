#!/bin/bash

coop=$1
coopno=$2
file=$3

line=$(awk -F\" -v coop=${coop} '{if ($2==coop) print $0}' $file | awk -F\, -v coopno="^"${coopno}"\)" '{if($4~coopno ) print $0}')

ncoop1=$(echo $line | awk -F\" '{print $6}')
ncoop1_no=$(echo $line | awk -F\, '{print $3}')


if grep -qx "$ncoop1" FOO/processes.txt; then
echo $ncoop1 $ncoop1_no >> FOO/temp.txt
else
./autocode.sh $ncoop1 $ncoop1_no $file
fi


ncoop2=$(echo $line | awk -F\" '{print $10}')
ncoop2_no=$(echo $line | awk -F\, '{print $6}')

if grep -qx "$ncoop2" FOO/processes.txt; then
echo $ncoop2 $ncoop2_no >> FOO/temp.txt
else
./autocode.sh $ncoop2 $ncoop2_no $file
fi

ncoop3=$(echo $line | awk -F\" '{print $14}')
ncoop3_no=$(echo $line | awk -F\, '{print $9}')

if grep -qx "$ncoop3" FOO/processes.txt; then
echo $ncoop3 $ncoop3_no >> FOO/temp.txt
else 
if [ "$ncoop3" != "" ] ; then
./autocode.sh $ncoop3 $ncoop3_no $file
fi

fi

ncoop4=$(echo $line | awk -F\" '{print $18}')
ncoop4_no=$(echo $line | awk -F\, '{print $12}')

if grep -qx "$ncoop4" FOO/processes.txt; then
echo $ncoop4 $ncoop4_no >> FOO/temp.txt
else
if [ "$ncoop4" != "" ] ; then
./autocode.sh $ncoop4 $ncoop4_no $file
fi
fi


ncoop5=$(echo $line | awk -F\" '{print $22}')
ncoop5_no=$(echo $line | awk -F\, '{print $15}')

if grep -qx "$ncoop5" FOO/processes.txt; then
echo $ncoop5 $ncoop5_no >> FOO/temp.txt
else
if [ "$ncoop5" != "" ] ; then
./autocode.sh $ncoop5 $ncoop5_no $file
fi
fi


