#!/bin/bash
# Wrapper script to import LDraw models into Recoil/Spring S3O format
# Usage: ./import_ldraw_model.sh <path/to/file.io>
#
# Example: ./import_ldraw_model.sh contrib/PowerStation.io
# Produces:
#   - Objects3d/PowerStation.s3o
#   - UnitTextures/PowerStation.dds (team alpha)
#   - UnitTextures/PowerStation2.dds (opaque)
#   - contrib/PowerStation.blend (for inspection)
#   - contrib/PowerStation.png and PowerStation2.png (intermediate)

set -e  # Exit on error

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path/to/file.io>"
    echo "Example: $0 contrib/PowerStation.io"
    exit 1
fi

LDRAW_FILE="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect Blender executable path
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Running on MSYS2/Windows - find Blender installation
    BLENDER_BASE="/c/Program Files/Blender Foundation"
    BLENDER_DIR=$(find "$BLENDER_BASE" -maxdepth 1 -type d -name "Blender *" 2>/dev/null | sort -V | tail -n 1)

    if [ -n "$BLENDER_DIR" ] && [ -f "$BLENDER_DIR/blender.exe" ]; then
        BLENDER="$BLENDER_DIR/blender.exe"
    else
        echo "Error: Could not find Blender installation in $BLENDER_BASE"
        exit 1
    fi
else
    # Linux/Mac - use blender from PATH
    BLENDER="blender"
fi

# Check if input file exists
if [ ! -f "$LDRAW_FILE" ]; then
    echo "Error: LDraw file '$LDRAW_FILE' not found"
    exit 1
fi

# Extract model name from filename (without extension)
MODEL_NAME="$(basename "$LDRAW_FILE" .io)"

echo "========================================="
echo "Importing LDraw model: $MODEL_NAME"
echo "========================================="

# Step 1: Run Blender import script
echo ""
echo "Step 1: Running Blender import script..."
"$BLENDER" --background --python "$SCRIPT_DIR/blender_import_script.py" -- "$LDRAW_FILE"

# Check if Blender export succeeded
if [ ! -f "$SCRIPT_DIR/MultiManicMiners/Objects3d/$MODEL_NAME.s3o" ]; then
    echo "Error: S3O export failed - MultiManicMiners/Objects3d/$MODEL_NAME.s3o not found"
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/contrib/$MODEL_NAME.png" ]; then
    echo "Error: Texture 1 not generated - contrib/$MODEL_NAME.png not found"
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/contrib/${MODEL_NAME}2.png" ]; then
    echo "Error: Texture 2 not generated - contrib/${MODEL_NAME}2.png not found"
    exit 1
fi

# Step 2: Convert textures to DDS
echo ""
echo "Step 2: Converting textures to DDS..."

# Texture 1: Team alpha mask (special materials show team color)
echo "  Converting texture 1 (team alpha)..."
"$SCRIPT_DIR/make_team_alpha.sh" \
    "$SCRIPT_DIR/contrib/$MODEL_NAME.png" \
    "$SCRIPT_DIR/MultiManicMiners/UnitTextures/$MODEL_NAME.dds"

# Texture 2: Opaque (flatten transparency)
echo "  Converting texture 2 (opaque)..."
"$SCRIPT_DIR/make_opaque_dds.sh" \
    "$SCRIPT_DIR/contrib/${MODEL_NAME}2.png" \
    "$SCRIPT_DIR/MultiManicMiners/UnitTextures/${MODEL_NAME}2.dds"

# Done!
echo ""
echo "========================================="
echo "Import complete!"
echo "========================================="
echo "Outputs:"
echo "  - MultiManicMiners/Objects3d/$MODEL_NAME.s3o"
echo "  - MultiManicMiners/UnitTextures/$MODEL_NAME.dds (team alpha)"
echo "  - MultiManicMiners/UnitTextures/${MODEL_NAME}2.dds (opaque)"
echo "  - contrib/$MODEL_NAME.blend (Blender file)"
echo "  - contrib/$MODEL_NAME.png (intermediate)"
echo "  - contrib/${MODEL_NAME}2.png (intermediate)"
echo ""
