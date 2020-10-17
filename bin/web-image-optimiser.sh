#!/usr/bin/env bash
# shellcheck disable=SC1090

# Inspired by https://developers.google.com/speed/docs/insights/OptimizeImages
set -e

CSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#include generic functions
. "$CSDIR/arg-parser.sh"

if ! command -v convert &> /dev/null
then
    echo "convert binary is required and could not be found, please install it."
    exit
fi

# processing input
Pattern=$(argValue pattern)

if [ "${#PATTERN}" == "0" ]
then
    Pattern="*.jpg"
fi

find . -type f -name "$Pattern" ! -name "*_converted.jpg" -execdir sh -c \
	'convert "$1" -sampling-factor 4:2:0 -strip -quality 80 -interlace JPEG -colorspace sRGB "${1%.jpg}_optimised.jpg"' _ {} \;
