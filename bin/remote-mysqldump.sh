#!/bin/bash
#
if [ -z "$DB_USER" ] || [ -z "$DB_PASS"  ] || [ -z "$DB_NAME"  ] || [ -z "$DB_HOST"  ]
then
	echo please call the script with compulsory env vars DB_USER, DB_PASS, DB_NAME, DB_HOST
	echo currently  "DB_USER = $DB_USER , DB_PASS = $DB_PASS , DB_NAME = $DB_NAME , DB_HOST = $DB_HOST"
	exit 1
fi

if [ -z "$FILE_NAME" ]
then
	echo using default DB_NAME as FILE_NAME prefix. Use FILE_NAME env if you want a custom name prefix for the archive.
	FILE_NAME="$DB_NAME"
fi

if [ -z "$BASE_PATH" ]
then
	echo "BASE_PATH used as base path to save archive, using default HOME/db_backup/ <- trailing slash required"
	BASE_PATH="$HOME/db_backup/"
fi

DATE_TIME=$(date +%Y-%m-%d_%H-%M)
DEST_FILE="${BASE_PATH}${FILE_NAME}_backup_${DATE_TIME}.sql"

### Make Nice - lower load
#renice 19 -p $$ &>/dev/null
### Non-Absolute links, check source exists
mkdir -p "$BASE_PATH"
cd "$BASE_PATH" || exit 1
echo "Command : mysqldump --host=$DB_HOST --user=$DB_USER --password=.... $DB_NAME > $DEST_FILE"
### mysqldump
mysqldump --single-transaction --host="$DB_HOST" --user="$DB_USER" --password="$DB_PASS" "$DB_NAME" > "$DEST_FILE"
if [ -f "$DEST_FILE" ]; then
	gzip "$DEST_FILE"
fi
exit 0
