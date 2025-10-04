#!/bin/bash
# ImageMagick script to create team color alpha mask for Recoil
# Usage: ./make_team_alpha_imagemagick.sh input.png output.png
#        ./make_team_alpha_imagemagick.sh input.png output.dds
#
# Creates alpha channel where:
# - #008d99 (teal) = white/opaque (team color shows)
# - Everything else = black/transparent (texture shows)

if [ $# -ne 2 ]; then
    echo "Usage: $0 input.png output.png"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

if [ ! -f "$INPUT" ]; then
    echo "Error: Input file '$INPUT' not found"
    exit 1
fi

echo "Processing $INPUT -> $OUTPUT"
echo "Creating alpha mask: #008d99 -> team color (white), rest -> texture (black)"

# Check if output is DDS and add compression settings
DDS_FLAGS=""
if [[ "$OUTPUT" == *.dds ]]; then
    DDS_FLAGS="-define dds:compression=dxt5"
    echo "Exporting as DDS with DXT5 compression"
fi

# Create mask: white on #008d99, very dark gray everywhere else (preserves RGB in mipmaps)
# Using gray2 (alpha=2/255) instead of black to prevent mipmap color corruption
magick "$INPUT" \
  \( +clone -alpha off -fuzz 1% -fill white -opaque "#008d99" -fuzz 0% -fill gray2 +opaque white \) \
  -compose copy-opacity -composite \
  $DDS_FLAGS \
  "$OUTPUT"

echo "Done! Saved to $OUTPUT"
