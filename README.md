# bash essentials
a container for generic bash scripts to be included in other projects
as a generic distributable bare list of libraries.  

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

## MoveRename command

Moves files from an old folder to a new one making sure it does not
overwrite files with the same size and instead it adds a prefix 
underscore to the new file when moved.

Aimed at moving log files to a new folder making sure no file is 
overwritten

Example call

```
$ bin/moverename.sh from=/home/bizmate/Documents/testFrom/ to=/home/bizmate/Documents/testTo/ pattern=app*
```