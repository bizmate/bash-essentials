#!/usr/bin/env bash
set -x

if [ -z "$RETETION_MINUTES" ] || [ -z "$RETENTION_LOCATION"  ]
then
	echo please call the script with compulsory env vars RETETION_MINUTES, RETENTION_LOCATION
	echo "example  RETETION_MINUTES=1520  RETENTION_LOCATION=/some/path simple-retention.sh"
	exit 1
fi

# https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
regex='^[0-9]+$'
if ! [[ $RETETION_MINUTES =~ $regex ]] ; then
   echo "error: RETETION_MINUTES is not an integer" >&2; exit 1
fi

if [ ! -d "$RETENTION_LOCATION" ]; then
  echo "RETENTION_LOCATION $DIRECTORY does not exist."
fi

# change permission not enabled find /var/lib/php/sessions -type f -mmin +1520 | xargs suchmod +wx

find "$RETENTION_LOCATION" -type f -mmin +"$RETETION_MINUTES" -delete
