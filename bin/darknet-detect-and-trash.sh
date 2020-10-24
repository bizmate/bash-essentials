#!/usr/bin/env bash
# shellcheck disable=SC1090

# export DARKNET_WORKSPACE_FOLDER=/home/bizmate/Documents/siti-web/darknet-ab/build/darknet/x64
# export YOLO_LIB_FOLDER=/home/bizmate/Documents/siti-web/yolo-lib

set -e

CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#include generic functions
. "$CSDIR/arg-parser.sh"

# check environment variables need
if [ -z "$YOLO_LIB_FOLDER" ] || [ -z "$DARKNET_WORKSPACE_FOLDER"  ]
then
	echo please call the script with compulsory env vars YOLO_LIB_FOLDER, DARKNET_WORKSPACE_FOLDER
	echo "example  YOLO_LIB_FOLDER=$YOLO_LIB_FOLDER  DARKNET_WORKSPACE_FOLDER=$DARKNET_WORKSPACE_FOLDER darknet-detect-and-delete.sh"
	exit 1
fi
#constants
videoAndImageFiles='.*\.\(jpg\|mp4\)'
requiredCommand=docker

if ! command -v $requiredCommand &> /dev/null
then
    echo "$requiredCommand is required and could not be found, please install it."
    exit
fi

# processing input
mediaFolder=$(argValue mediaFolder)

if [ -z "${mediaFolder}" ]
then
    mediaFolder="$PWD"
fi

export mediaFolder

#processing function
checkAndTrash() {
	extension="${1##*.}"
	# filename="${1%.*}"
	echo "checking file $1 with extension $extension under folder $mediaFolder"

	if [[ -f "$1.log" ]]
	then
		fpsCount=$(grep -c FPS "$1.log")

		echo "FPS Count $fpsCount"
		if [[ "$fpsCount" -gt "0" ]];
		then
			echo "$1 was already checked, returning 0"
			return 0
		else
			echo "$1 was not checked"
		fi
	fi

	if [[ "$extension" == 'jpg' ]]
	then
		docker run --gpus all --rm -v "$DARKNET_WORKSPACE_FOLDER":/workspace -v "$YOLO_LIB_FOLDER":/yolo-lib \
		-v "$mediaFolder":/images -w /workspace daisukekobayashi/darknet:gpu-cv darknet detector test data/coco.data \
		/yolo-lib/yolov3.cfg /yolo-lib/yolov3.weights  "/images/$1" -dont_show -ext_output > "$1.log"
	else
		docker run --gpus all --rm -v "$DARKNET_WORKSPACE_FOLDER":/workspace -v "$YOLO_LIB_FOLDER":/yolo-lib \
		-v "$mediaFolder":/images -w /workspace daisukekobayashi/darknet:gpu-cv darknet detector demo data/coco.data \
		/yolo-lib/yolov3.cfg /yolo-lib/yolov3.weights  "/images/$1" -dont_show -ext_output | awk '/Objects:/,/FPS/' \
		> "$1.log"
	fi

	if [[ -s "$1.log" ]]
	then
		echo "good detection for file $1.log"
		personCount=$(grep -c person "$1.log")

		if [[ "$personCount" -eq "0" ]];
		then
		   echo "moving $mediaFolder/$1 to trash";
		   gvfs-trash "$mediaFolder/$1"
		fi
	else
		echo "broken detection for file $1.log"
	fi
}

export -f checkAndTrash

find "$mediaFolder" -type f -regex "$videoAndImageFiles" -execdir bash -c 'checkAndTrash "$0"' {} \;
