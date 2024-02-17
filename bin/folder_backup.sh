#!/usr/bin/env bash
echo Running Backup
set -e
if [ -z "$SOURCE_FOLDER" ]
then
	echo please call the script with compulsory env var SOURCE_FOLDER
	echo currently  "SOURCE_FOLDER = $SOURCE_FOLDER , DESTINATION_FOLDER = $DESTINATION_FOLDER, BACKUP_NAME = $BACKUP_NAME "
	exit 1
fi

if [ -z "$BACKUP_NAME" ]
then
	echo using default SOURCE_FOLDER as BACKUP_NAME prefix. Use BACKUP_NAME env if you want a custom name prefix.
	BACKUP_NAME="$SOURCE_FOLDER"
fi

if [ -z "$DESTINATION_FOLDER" ]
then
	echo using default DESTINATION_FOLDER. Use DESTINATION_FOLDER env if you want to store in another folder.
	DESTINATION_FOLDER=./sites_backup
fi

mkdir -p "$DESTINATION_FOLDER"

source=$SOURCE_FOLDER
date_time=$(date +%Y-%m-%d_%H-%M)
dest=$DESTINATION_FOLDER/"$BACKUP_NAME"_$date_time.tgz

### TAR
/usr/bin/tar -czvf "$dest" "$source"
