# Bash Essentials
A repository for generic bash scripts to be included in other projectsas a generic distributable bare list of libraries.
Please read the [License](./LICENSE.md) before using.

TODO: look into https://github.com/bpkg/bpkg

## ArgParser
bin/arg-parser.sh is a generic argument parser. It has limitations as
it does not handle spaces, so remember it is based on word splitting.

To import it

```
CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#include arg parser - fetch args with function argValue
. "$CSDIR/arg-parser.sh"
```

and to get your params just add the following if you parameter name is `from`
`FROM=$(argValue from)`

## MoveRename command

Moves files from an old folder to a new one making sure it does not
overwrite files with the same size and instead it adds a prefix
underscore to the new file when moved.

Aimed at moving log files to a new folder making sure no file is
overwritten

Example call

```
$ bin/moverename.sh from=/home/bizmate/Documents/testFrom/ to=/home/bizmate/Documents/testTo pattern=app*
```

## Wait for Docker Compose

When using docker compose in detached mode it might take sometime before
the state of a container is ready to perform the full operations it is
required for. For instance apache takes sometime to start and be
available on a port, the same if you are doing some file packing in the
container when running a build, for instance `composer install`

Example on how to leverage this script
./bin/wait_for_docker.bash "ready to handle connections"

## Docker Compose check for X amount of 0 exited processes
When running docker-compose up in detached mode the processes/containers might not be ready or might fail after sometime
from the up sequence. 
This script checks 20 times with 2 seconds intervals, so up to approximately 40 seconds, how many docker containers 
exited with a 0 exit code.
 
For instance if using composer and another script you would expect its container to exit 
with code 0. As they are two containers you can call the script such as

`bin/docker-compose-exit-check.sh 2`

## Docker Compose sample command to register Gitlab runners to projects

It expects to be run on a docker host where the `gitlab-runner` is runnig from docker-compose.

`docker-compose-register-gitlab-runner.sh token1,token2`

# Selected Tables import/export
Can be used to import and export specific tables from a db. Example:

```
DB_USER=root  DB_PASS=qwerty  DB_NAME=wordpress  DB_HOST=127.0.0.1 DB_PORT=3307 FILE_PATH="fixtures/file.sql" bin/selected-tables-import-export.sh "wp_ad2kb8_sib_model_forms wp_ad2kb8_sib_model_users"
```


## [Remote db file restore](/docs/REMOTE_DB_FILE_RESTORE.md)
## [Folder Backup](/docs/FOLDER_BACKUP.md)
## [Bash Docker](/docs/BASH_DOCKER.md)
## [Environment Replacement](/docs/ENV_REPLACE.md)
## [Optimise web images](/docs/OPTIMISE_FOR_WEB.md)
## [Detect and trash images without persons](/docs/DARKNET_DETECT_AND_TRASH.md)
## [Generate SSH key for Github using Docker](/docs/SSH_KEYGEN_GITHUB_DOCKER.md)
## [Rename Files with Specific Dates](/docs/FILE_WITH_DATES_RENAME.md)
## [Natwest bank statements naming script](/docs/NATWEST_STATEMENT_RENAME.md)
## [Simple Retention](/docs/SIMPLE_RETENTION.md)

# Build Status

[![Build Status](https://travis-ci.com/bizmate/bash-essentials.svg?branch=master)](https://travis-ci.com/bizmate/bash-essentials)
