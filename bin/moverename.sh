#!/usr/bin/env bash
## moves files from one folder to another one, renaming a file if it has the same name and different size
CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#include arg parser - fetch args with function argValue
. "$CSDIR/arg-parser.sh"

FROM=$(argValue from)
PATTERN=$(argValue pattern)
TO=$(argValue to)

#globa evil of bash variables
fileExistsWithDifferentSizeVal=false
moveToFile=''

fileExistsWithDifferentSize(){
	# fromFile 	$1
	# toFile 	$2
	echo "Running fileExistsWithDifferentSize with args $1 and $2"
	if [ -f "$2" ] && [ "$(stat -c %s "$1")" -ne "$(stat -c %s "$2")" ]; then
		fileExistsWithDifferentSizeVal=true
	else
		fileExistsWithDifferentSizeVal=false
	fi
}

#fileExistsWithDifferentSize /home/bizmate/Documents/testFrom/application201707040000.log /home/bizmate/Documents/testTo/application201707040000.log

#exit 1;

rename(){
	moveToFile=$(echo "$1" | sed 's/\./_./')
}

if [ -z "${FROM}" ] || [ -z "${TO}" ] || [ -z "${PATTERN}" ] ; then
	echo "Please call script with 'bin/moverename.sh from=/path to=/path pattern=application*'";
else
	echo "Trying to move files with pattern $PATTERN from $FROM to $TO";

	if [ ! -d "$FROM" ]; then
		echo "Directory from = $FROM not found";
		exit 1;
	fi

	if [ ! -d "$TO" ]; then
		echo "Directory to = $TO not found";
		exit 1;
	fi

	files=(`find "$FROM" -name "$PATTERN" -type f `)

 	#printf '%s\n' "${files[@]}";
	for matchfile in "${files[@]}"; do
		moveToFile=$(basename "${matchfile}")
		echo "Processing File $moveToFile";
		# moving file if it does not exist
		if [ ! -f "$TO/$moveToFile" ]; then
			echo "Moving file $moveToFile"
			mv "$matchfile" "$TO/$moveToFile"
		else
			# https://stackoverflow.com/questions/23331864/check-if-two-files-are-different-sizes-in-bash
			#if [ $(stat -c %s ${file}) -ne $(stat -c %s "$TO/$moveToFile") ]; then
               # echo"They're different."

            #fi
			echo "${moveToFile} exists"
			#rename $moveToFile
			#echo "new move to file name $moveToFile"

			fileExistsWithDifferentSize "$matchfile" "$TO/$moveToFile"

			echo "$fileExistsWithDifferentSizeVal <-"

			while [ "$fileExistsWithDifferentSizeVal" = true ]
            do
				echo "File $matchfile has same size as $TO/$moveToFile"
				rename "$moveToFile"
				fileExistsWithDifferentSize "$matchfile" "$TO/$moveToFile"
				if [ ! -f "$TO/$moveToFile" ]; then
					echo "Moving file to $moveToFile"
					mv "$matchfile" "$TO/$moveToFile"
				fi
            done
		fi
	done
fi

