#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2016

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
	filePath=$( dirname "$1" )
	fileName=$( basename "$1" )
	# filename="${1%.*}"
	echo "checking path $filePath fileName $fileName file $1 with extension $extension under folder $mediaFolder"

	if [[ -s $filePath/$fileName ]];
	then
		fileSize="$(wc -c "$filePath/$fileName" | awk '{print $1}')"
		echo "file has something fileSize: $fileSize";
    if [[ "$fileSize" -lt 500000 ]]  && [[ "$extension" == 'mp4' ]]; then
      echo "PARTIAL Video file $filePath/$fileName is too small. Might be partial. Deleting"
      gio trash "$filePath/$fileName"
      return 0
    fi
	else
		echo "$fileName is empty, deleting and  returning 0"
		gio trash "$filePath/$fileName"
		return 0
	fi


	if [[ -f "$1.log" ]]
	then
		fpsCount=$(grep -c -e 'Predicted' -e 'FPS' "$1.log")

		echo "FPS Count $fpsCount"
		if [[ "$fpsCount" -gt "0" ]];
		then
			echo "$fileName was already checked, returning 0"
			return 0
		else
			echo "$fileName was not checked"
		fi
	fi

	if [[ "$extension" == 'jpg' ]]
	then
		docker run --gpus all --rm -v "$DARKNET_WORKSPACE_FOLDER":/workspace -v "$YOLO_LIB_FOLDER":/yolo-lib \
		-v "$filePath":/images -w /workspace daisukekobayashi/darknet:gpu-cv darknet detector test data/coco.data \
		/yolo-lib/yolov3.cfg /yolo-lib/yolov3.weights  "/images/$fileName" -dont_show -ext_output > "$1.log"

		RESULT=$?
		if [ $RESULT -eq 0 ]; then
      echo success >> "$1.log"
    else
      echo "Failed executing command $RESULT" >> "$1.log"
    fi
	else
		docker run --gpus all --rm -v "$DARKNET_WORKSPACE_FOLDER":/workspace -v "$YOLO_LIB_FOLDER":/yolo-lib \
		-v "$filePath":/images -w /workspace daisukekobayashi/darknet:gpu-cv darknet detector demo data/coco.data \
		/yolo-lib/yolov3.cfg /yolo-lib/yolov3.weights  "/images/$fileName" -dont_show -ext_output | awk '/Objects:/,/FPS/' \
		> "$1.log"

		RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo success >> "$1.log"
    else
      echo "Failed executing command $RESULT" >> "$1.log"
    fi
	fi

#	if [[ $? != 124 ]]
#	then
#		echo "exited with $?" > "$1.timeoutError.log"
#	fi

	if [[ -s "$1.log" ]]
	then
		if [[ $extension == "jpg" ]]  ; then checkString="Predicted"; else checkString="FPS"; fi
		checkCount=$(grep -c $checkString "$1.log")
		isFailed=$(grep -c Failed "$1.log")

		if [[ "$isFailed" -ne "0" ]];
    then
      echo "broken/failed detection for file $1.log"
      exit 1
    fi

		if [[ "$checkCount" -eq "0" ]];
		then
			echo "broken detection for file $1.log"
		fi

		personCount=$(grep -c person "$1.log")
		if [[ "$personCount" -eq "0" ]];
		then
		   echo "moving $filePath/$fileName to trash";
		   gio trash "$filePath/$fileName"
		fi
	else
		echo "broken detection for file $1.log"
	fi
}

export -f checkAndTrash

find "$mediaFolder" -type f -regex "$videoAndImageFiles" -exec timeout 300 bash -c 'checkAndTrash "$0"' {} \;
