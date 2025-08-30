#!/bin/bash

# Usage: ./spm_analysis.sh <DATASET_DIR> <MATLAB_DIR> <CAT12_DIR> <VBM_CONFIG_FILE> 

DATASET_DIR=$1
MATLAB_DIR=$2
CAT12_DIR=$3
VBM_CONFIG_FILE=$4 # path to cat_vbm_atlas.m

output=""
for a in $DATASET_DIR/*/mri/norm.nii.gz;
do 
b=`echo $a | cut -d "/" -f 7`;
if [ ! -d $DATASET_DIR/$b/mri/mri/ ]
then
output=$output" "$a
fi
done

taskset -c 0-5 $CAT12_DIR/cat_batch_cat.sh -p 6 -m $MATLAB_DIR -d $VBM_CONFIG_FILE $output
