#!/usr/bin/env bash
CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#include arg parser - fetch args with function argValue
# shellcheck source=bin/arg-parser.sh
. "$CSDIR/arg-parser.sh"

FILE_NAME=$(argValue file)
DEBUG=$(argValue debug)
ENV=$(env)

if [ ! -f "$CSDIR/../$FILE_NAME" ]; then
    echo "File $FILE_NAME does not exist, exiting "
    exit 1;
fi

FILE_CONTENT=$(cat "$CSDIR/../$FILE_NAME")

mapfile -t env_array < <( printf "%s" "$ENV" )

for s in "${env_array[@]}"; do
    if [ -n "$DEBUG" ]; then
        echo "Processing ${s} "
    fi
    # https://www.tutorialkart.com/bash-shell-scripting/bash-split-string/
    IFS='='
    read -ra ENV_VAR <<< "${s}"
    KEY=${ENV_VAR[0]}
    VALUE=${ENV_VAR[1]}
    if [ -n "$DEBUG" ]; then
        echo "Variable split, key: ${ENV_VAR[0]} value: ${ENV_VAR[1]}"
    fi
    # replacing string -
    # FILE_CONTENT=$(echo "$FILE_CONTENT" | sed "s/{{$KEY}}/${VALUE}/g")
    FILE_CONTENT="${FILE_CONTENT//%$KEY%/"$VALUE"}"

done

echo "$FILE_CONTENT";