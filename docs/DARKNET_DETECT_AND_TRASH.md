# Darknet Detect and Trash

Script using darknet inside docker to delete videos or images without person entities detected.

### Requirements
- docker
- yolo library configuration and weights inside a specific folder and folder exported as environment variable value.
	It currently uses YOLO 3 but looking into upgrading to 4.
- darknet build folder is used within docker, export the required variable after running make inside [darknet](https://github.com/AlexeyAB/darknet)
- a GPU is required, it will not work correctly if an Nvidia GPU is not present

## Run command

`bin/darknet-detect-and-delete.sh mediaFolder=/path/to/files`

It will find all jpg and mp4 files, only these types are being scanned at the moment.
Argument is optional, if omitted it will use current working folder.

### Notes
- https://github.com/AlexeyAB/darknet
- https://github.com/daisukekobayashi/darknet-docker

[Go Back](../README.md)
