#!/bin/sh

while getopts u:d:l:s:b:r: option
do
case "${option}"
in
u) url=${OPTARG};;
d) output_dir=${OPTARG};;
s) showname=${OPTARG};;
r) radiostation=${OPTARG};;
l) duration=${OPTARG};;
b) bucket=${OPTARG};;
esac
done

date=`date +"%Y-%m-%d_%a_%H%M%P"`
output_filename=$showname.${date}

cd $output_dir

streamripper $url -d $output_dir -l $duration -a $output_filename -o always

aws s3 cp $output_dir$output_filename.aac s3://$bucket/$radiostation/$output_filename.aac
