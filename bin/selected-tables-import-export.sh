#!/usr/bin/env bash
# shellcheck disable=SC1090

set -e
# set -o xtrace

#env variables as input
if [ -z "$DB_USER" ] || [ -z "$DB_PASS"  ] || [ -z "$DB_NAME"  ] || [ -z "$DB_HOST"  ] || [ -z "$FILE_PATH" ]
then
	echo please call the script with compulsory env vars DB_USER, DB_PASS, DB_NAME, DB_HOST and add tables input to export.
	echo currently  "DB_USER=$DB_USER DB_PASS=$DB_PASS DB_NAME=$DB_NAME DB_HOST=$DB_HOST FILE_PATH=$FILE_PATH bin/selected-tables-import-export.sh \"table1 table two\""
	exit 1
fi

if [ -z "${DB_PORT}" ]
then
    DB_PORT=3306
fi

# processing input
tables=$1

if [ -z "${tables}" ]
then
	echo importing
	if [[ -f "$FILE_PATH" ]]
	then
		echo "File $FILE_PATH not found for import"
		exit 1
	fi
	# running import
    mysql -h "$DB_HOST -u $DB_USER -p$DB_PASS -P $DB_PORT $DB_NAME < $FILE_PATH"
else
	echo exporting "$tables"
	# running export
	# https://dba.stackexchange.com/questions/9306/how-do-you-mysqldump-specific-tables
	read -ra tables_arr <<<"$tables"; declare -p tables_arr
	mysqldump --single-transaction --host="$DB_HOST" --user="$DB_USER" --password="$DB_PASS" --port="$DB_PORT" "$DB_NAME" "$tables_arr" > "$FILE_PATH"
fi
