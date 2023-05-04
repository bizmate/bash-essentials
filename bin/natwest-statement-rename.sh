#!/usr/bin/env bash
# shellcheck disable=SC2016
# shellcheck disable=SC1091

CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#include arg parser - fetch args with function argValue
# shellcheck source=bin/arg-parser.sh
. "$CSDIR/arg-parser.sh"

## ensure pdftotxt is installed
if ! command -v pdftotext &> /dev/null
then
    echo "pdftotext could not be found, please install it to use the script"
    exit
fi

DEFAULT_FILENAME_PREFIX="statement_"

# files are given a date and a name based on this prefix such as PREFIXYYYYMMDD.pdf
filePrefix=$(argValue file-prefix)
export filePrefix
filePrefixLength=$( echo -n "$filePrefix" | wc -c )

if [[ "$filePrefixLength" == 0 ]] ; then
  export filePrefix="$DEFAULT_FILENAME_PREFIX"
fi

getFormattedDateFromFile() {
  ## This extracts the period such as 9 Mar 2023 to 6 Apr 2023
  periodLine=$( pdftotext -layout "$1" - | grep Period | head -n1 )
  periodInVerbalFormat=${periodLine#*to}
  periodYYYYMMDD=$( date -d "$periodInVerbalFormat" +'%Y%m%d' )

  dateLength=$( echo -n "$periodYYYYMMDD" | wc -c )

  if [[ $dateLength != 8 ]]; then
    echo "date is not well formatted. exiting"
    exit
  fi

  echo "Line $periodLine ---- End date: $periodInVerbalFormat . New date formatted: $periodYYYYMMDD"
}

export -f getFormattedDateFromFile

renameStatement(){
  getFormattedDateFromFile "$1"

  extension="${1##*.}"
  echo "Renaming to $filePrefix$periodYYYYMMDD.$extension"
  mv "$1" "$filePrefix$periodYYYYMMDD.$extension"
}

export -f renameStatement

find . -maxdepth 1 -name "*.pdf" -type f -exec timeout 300 bash -c 'renameStatement "$0"' {} \;
