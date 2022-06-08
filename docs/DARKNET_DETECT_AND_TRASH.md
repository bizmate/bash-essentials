# Darknet Detect and Trash

Script using darknet inside docker to delete videos or images without person entities detected.

## Requirements
- docker
- yolo and darknet workspace folders
- a GPU is required, it will not work correctly if an Nvidia GPU is not present

### Yolo and Darknet requirements

- yolo library configuration and weights inside a specific folder and folder exported as environment variable value.
	It currently uses YOLO 3 but looking into upgrading to 4.
- darknet build folder is used within docker, export the required variable after running make inside [darknet](https://github.com/AlexeyAB/darknet)

```
export DARKNET_WORKSPACE_FOLDER="$HOME/Documents/sites/darknet-ab/build/darknet/x64"
export YOLO_LIB_FOLDER="$HOME/Documents/sitis/yolo-lib"
```

To download yolo get the links from the [darknet readme](https://github.com/AlexeyAB/darknet/blob/master/README.md)
To ensure the darknet workspace is configured with the right configuration files, like the coco configuration
please install darknet as it will create the build folder and all necessary files.

## Run command

`bin/darknet-detect-and-trash.sh mediaFolder=/path/to/files`

It will find all jpg and mp4 files, only these types are being scanned at the moment.
Argument is optional, if omitted it will use current working folder.

It will create log files for the images and videos scanned so it will not scan them again a second time.

### Notes
- https://github.com/AlexeyAB/darknet
- https://github.com/daisukekobayashi/darknet-docker

[Go Back](../README.md)
