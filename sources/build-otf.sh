#!/bin/bash
set -e

# Ensure we run from the directory this script lives in.
cd "$(dirname "$0")"

fontNames="SilkRemingtonTypewriterATR SilkRemingtonTypewriterATR-Italic"

##########################################

echo ".
GENERATING OTF
."
OT_DIR=../fonts/otf
rm -rf $OT_DIR
mkdir -p $OT_DIR

for fontName in $fontNames; do
    fontmake -u ufo/${fontName}.ufo -o otf --output-dir $OT_DIR
done

##########################################

echo ".
POST-PROCESSING OTF
."
if command -v gftools &> /dev/null; then
    otfs=$(ls $OT_DIR/*.otf)
    for font in $otfs
    do
        gftools fix-hinting $font
        [ -f $font.fix ] && mv $font.fix $font
    done
else
    echo "gftools not installed; skipping fix-hinting."
fi

find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

echo ".
COMPLETE!
."
