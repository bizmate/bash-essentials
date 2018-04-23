#!/usr/bin/env bash

set -x

if [ -z "$DB_USER" ] || [ -z "$DB_PASS"  ] || [ -z "$DB_NAME"  ] || [ -z "$DB_HOST"  ] || [ -z "$FILE_NAME"  ] || [ -z "$BASE_URL"  ]
then
	echo please call the script with compulsory env vars DB_USER, DB_PASS, DB_NAME, DB_HOST
	echo example  "DB_USER=$DB_USER  DB_PASS=$DB_PASS  DB_NAME=$DB_NAME  DB_HOST=$DB_HOST FILE_NAME=$FILE_NAME BASE_URL=url s3_db_restore.sh"
	exit 1
fi

curl -o "$FILE_NAME" "$BASE_URL$FILE_NAME"

if [[ $FILE_NAME = *".gz" ]]; then
	echo "Gunzipping $FILE_NAME"
	gunzip "$FILE_NAME"

	suffix=".gz"
	FILE_NAME=${FILE_NAME%$suffix}
	echo "Gunzipped into $FILE_NAME"
fi

mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < $FILE_NAME

rm $FILE_NAME