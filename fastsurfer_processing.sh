#!/bin/bash

# Usage: ./fastsurfer_processing.sh <DATASET_DIR> <OUTPUT_DIR> <FREESURFER_LICENSE> [GPU_ID] [CPU_RANGE]

DATASET_DIR=$1
OUTPUT_DIR=$2
FREESURFER_LICENSE=$3

# Optionale Argumente mit Defaults
GPU_ID=${4:-0}          # Default: GPU 0
CPU_RANGE=${5:-0-3}     # Default: CPUs 0-3

if [ -z "$DATASET_DIR" ] || [ -z "$OUTPUT_DIR" ] || [ -z "$FREESURFER_LICENSE" ]; then
  echo "Usage: $0 <DATASET_DIR> <OUTPUT_DIR> <FREESURFER_LICENSE> [GPU_ID] [CPU_RANGE]"
  exit 1
fi

for i in $(find "$DATASET_DIR" -type f -name "*.nii"); do
    a=$(basename "$i" .nii)
    dir_name=$(dirname "$i")

    if [ ! -d "$OUTPUT_DIR/$a" ]; then
        docker run --gpus "device=$GPU_ID" \
            -v "$dir_name":/data \
            -v "$OUTPUT_DIR":/output \
            -v "$FREESURFER_LICENSE":/fs_license \
            -i -t -P \
            --cpuset-cpus="$CPU_RANGE" \
            --rm fastsurfer:gpu \
            --fs_license /fs_license/license.txt \
            --t1 /data/"$a".nii \
            --sid "$a" \
            --sd /output \
            --parallel
    fi
done
