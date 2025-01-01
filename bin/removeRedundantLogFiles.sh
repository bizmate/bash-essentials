#!/usr/bin/env bash

# find .log files and save them in the files array 
# https://stackoverflow.com/questions/5905054/how-can-i-recursively-find-all-files-in-current-and-subfolders-based-on-wildcard
# https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash/54561526#54561526
readarray -d '' files < <(find . -name "*.log" -print0)


for s in "${files[@]}"; do
    
    originalFile=${s//.log/}

    echo "Processing ${s}, original file $originalFile."

    if [ ! -f "$originalFile" ]; then
	  echo "Original file $originalFile does not exist. Removing log file."
	  gio trash "${s}"
	fi
done