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

if [ "${#Pattern}" == "0" ]
then
    Pattern="*.png"
fi

find . -type f -name "$Pattern" ! -name "*_optimised.jpg" -execdir sh -c \
	'convert "$1" -strip -colorspace sRGB "${1%.png}_optimised.png"' _ {} \;

#todo $ convert Slider1.png -strip Slider1_optimised.png
#todo checkout https://web.dev/uses-responsive-images/?utm_source=lighthouse&utm_medium=unknown
#
