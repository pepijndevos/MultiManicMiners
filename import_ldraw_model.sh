#!/bin/bash
# Wrapper script to import LDraw models into Recoil/Spring S3O format
# Usage: ./import_ldraw_model.sh <model_name>
#
# Example: ./import_ldraw_model.sh PowerStation
# Produces:
#   - Objects3d/PowerStation.s3o
#   - UnitTextures/PowerStation.dds (team alpha)
#   - UnitTextures/PowerStation2.dds (opaque)
#   - contrib/PowerStation.blend (for inspection)
#   - contrib/PowerStation.png and PowerStation2.png (intermediate)

set -e  # Exit on error

if [ $# -ne 1 ]; then
    echo "Usage: $0 <model_name>"
    echo "Example: $0 PowerStation"
    exit 1
fi

MODEL_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if input file exists
if [ ! -f "$SCRIPT_DIR/contrib/$MODEL_NAME.ldr" ]; then
    echo "Error: LDraw file 'contrib/$MODEL_NAME.ldr' not found"
    exit 1
fi

echo "========================================="
echo "Importing LDraw model: $MODEL_NAME"
echo "========================================="

# Step 1: Run Blender import script
echo ""
echo "Step 1: Running Blender import script..."
blender --background --python "$SCRIPT_DIR/blender_import_script.py" -- "$MODEL_NAME"

# Check if Blender export succeeded
if [ ! -f "$SCRIPT_DIR/Objects3d/$MODEL_NAME.s3o" ]; then
    echo "Error: S3O export failed - Objects3d/$MODEL_NAME.s3o not found"
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
    "$SCRIPT_DIR/UnitTextures/$MODEL_NAME.dds"

# Texture 2: Opaque (flatten transparency)
echo "  Converting texture 2 (opaque)..."
"$SCRIPT_DIR/make_opaque_dds.sh" \
    "$SCRIPT_DIR/contrib/${MODEL_NAME}2.png" \
    "$SCRIPT_DIR/UnitTextures/${MODEL_NAME}2.dds"

# Done!
echo ""
echo "========================================="
echo "Import complete!"
echo "========================================="
echo "Outputs:"
echo "  - Objects3d/$MODEL_NAME.s3o"
echo "  - UnitTextures/$MODEL_NAME.dds (team alpha)"
echo "  - UnitTextures/${MODEL_NAME}2.dds (opaque)"
echo "  - contrib/$MODEL_NAME.blend (Blender file)"
echo "  - contrib/$MODEL_NAME.png (intermediate)"
echo "  - contrib/${MODEL_NAME}2.png (intermediate)"
echo ""
