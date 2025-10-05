#!/bin/bash
# ImageMagick script to convert PNG to opaque DDS
# Usage: ./make_opaque_dds.sh input.png output.dds
#
# Removes transparency by flattening against black background

if [ $# -ne 2 ]; then
    echo "Usage: $0 input.png output.dds"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

if [ ! -f "$INPUT" ]; then
    echo "Error: Input file '$INPUT' not found"
    exit 1
fi

echo "Processing $INPUT -> $OUTPUT"
echo "Flattening transparency against black background"

# Flatten alpha channel against black, then save as DDS with DXT1 (no alpha)
magick "$INPUT" \
  -background black -alpha remove \
  -define dds:compression=dxt1 \
  "$OUTPUT"

echo "Done! Saved to $OUTPUT"
