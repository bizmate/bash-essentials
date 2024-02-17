# Folder Backup

Example
```
SOURCE_FOLDER=www.mywebsite.com  BACKUP_NAME=mywebsite DESTINATION_FOLDER="afolder" bin/s3_db_restore.sh
```
BACKUP_NAME and DESTINATION_FOLDER are optional. Defaults are applied if not specified.
Notice the script will try to create the destination folder

If calling the execution breaks try to export the variables first and
then call the script

[Go Back](../README.md)
