#!/bin/bash
set -e

# Ensure we run from the directory this script lives in.
cd "$(dirname "$0")"

fontNames="SilkRemingtonTypewriterATR SilkRemingtonTypewriterATR-Italic"

##########################################

echo ".
GENERATING TTF
."
TT_DIR=../fonts/ttf
rm -rf $TT_DIR
mkdir -p $TT_DIR

for fontName in $fontNames; do
    fontmake -u ufo/${fontName}.ufo -o ttf --output-dir $TT_DIR
done

##########################################

echo ".
POST-PROCESSING TTF
."
has_ttfautohint=false
command -v ttfautohint &> /dev/null && has_ttfautohint=true
has_gftools=false
command -v gftools &> /dev/null && has_gftools=true

ttfs=$(ls $TT_DIR/*.ttf)
for font in $ttfs
do
    if [ "$has_ttfautohint" = true ]; then
        # The logo glyph is too complex to autohint; exclude it.
        ttfautohint -m misc/ttfautohint-control.txt $font $font.fix
        [ -f $font.fix ] && mv $font.fix $font
    fi
    if [ "$has_gftools" = true ]; then
        gftools fix-hinting $font
        [ -f $font.fix ] && mv $font.fix $font
    fi
done

if [ "$has_ttfautohint" = false ] && [ "$has_gftools" = false ]; then
    echo "No post-processing tools installed; output is unhinted."
fi

find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

echo ".
COMPLETE!
."
