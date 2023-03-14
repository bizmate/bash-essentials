#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2016
# finds files with certain prefix and renames the date part of the filename showing as DD-MM-YYYY into YYYYMMDD
# =~ operator explained at https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#Conditional-Constructs

CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#include arg parser - fetch args with function argValue
# shellcheck source=bin/arg-parser.sh
. "$CSDIR/arg-parser.sh"

filePrefix=$(argValue file-prefix)
rename=$(argValue rename)
export rename;

replaceFilename() {
  pattern="([[:digit:]]{2})-([[:digit:]]{2})-([[:digit:]]{4})"
  #extension="${1##*.}"
  #filePath=$( dirname "$1" )
  fileName=$( basename "$1" )

  #echo "checking path $filePath fileName $fileName file $1 with extension $extension"

  if [[ "$fileName" =~ $pattern ]]; then
    echo "the match is ${BASH_REMATCH[0]} , day: ${BASH_REMATCH[1]} month: ${BASH_REMATCH[2]} year: ${BASH_REMATCH[3]}"

    oldDate="${BASH_REMATCH[0]}"
    newDate="${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"

    # echo "bash rematch 0:  ${BASH_REMATCH[0]} , newDate: $newDate"
    newFileName=${fileName//$oldDate/$newDate}
    echo "Rename preview $fileName to $newFileName ? rename: $rename"
    if [ -n "$rename" ] ; then
      echo "Renaming $fileName to $newFileName"
      mv "$fileName" "$newFileName"
    fi
  else
    echo "no match found in file $fileName"
  fi
}
export -f replaceFilename

find . -maxdepth 1 -name "$filePrefix*" -type f -exec timeout 300 bash -c 'replaceFilename "$0"' {} \;
echo "fucking rename $rename"
