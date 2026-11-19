#!/bin/bash
set -e

# Ensure we run from the directory this script lives in.
cd "$(dirname "$0")"

if [[ ! -d ../fonts/webfonts ]]; then
    mkdir ../fonts/webfonts
fi

for font in ../fonts/ttf/*; do
    FA=`basename "$font"`
    FN=${FA::-4}
    # woff2_compress only accepts one argument and writes the .woff2 next
    # to the input file, so compress in place then move it into position.
    if command -v woff2_compress &> /dev/null; then
        woff2_compress "$font"
    else
        python3 -m fontTools.ttLib.woff2 compress "$font"
    fi
    mv "../fonts/ttf/${FN}.woff2" "../fonts/webfonts/${FN}.woff2"
done
