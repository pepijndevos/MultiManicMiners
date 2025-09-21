# Importing Brickink Studio models into Recoil via Blender

This process requires the [Import LDraw](https://github.com/TobyLobster/ImportLDraw) and [s3o](https://github.com/ChrisFloofyKitsune/s3o-blender-tools) Blender plug-in.

## Import into Blender

In Bricklink Studio:

1. Open the Lego model
2. File -> Export as -> Export as LDraw

In Blender:

1. Hit N to open the sidebar and select the S3O tab
2. Click Add S3O root
3. File -> Import -> LDraw, Change the following settings:
    - LDraw filepath: C:/Program Files/Studio 2.0/ldraw
    - Scale: 1000
    - No Environment
    - Low resolution
    - No beveled edges
    - No curved wall normals
4. Select relevant parts of the model and combine them by pressing CTRL+J
5. Select the Lego Mesh and ctrl+click the S3O root, then with the mouse on the model press CTRL+P to reparent the imported model to the S3O root.

## Model export

In the bottom right properties go to the data tab (axis), and tweak the S3O data.

Then, in the S3O panel, hit Export *.s3o

## Texture export

These Lego models use materials that don't render inside Recoil, so we'll need to "bake" them into a separate texture image according to [this format](https://springrts.com/wiki/3DModels:Textures)

### Step 1: Create a New UV Map for All Meshes

1. **Open the UV Editing workspace**:
   - Look at the top of the Blender window for workspace tabs
   - Click on "UV Editing" tab (or go to the "+" button and add UV Editing workspace if not visible)

2. **Access UV Maps**:
   - Select your model in the 3D viewport (right side panel)
   - On the right side of the screen, find the Properties panel (icons on the right)
   - Click the green triangle icon (Object Data Properties)
   - Scroll down to find "UV Maps" section

3. **Check existing UV maps**:
   - If your model already has UV maps listed, note them
   - If no UV maps exist, you'll need to create one first

4. **Create a new UV map for baking**:
   - Click the "+" button next to UV Maps to add a new one
   - Double-click the new UV map and rename it to "baked" or "unified"
   - Make sure this new UV map is highlighted (selected) but the camera icon should remain on the original UV

5. **Unwrap the model with the new UV**:
   - Enter Edit Mode (press Tab with the model selected)
   - Select all geometry (press A to select all)
   - Press U to open the UV menu
   - Choose "Smart UV Project" or "Unwrap"
   - In the popup settings (bottom left), you can adjust:
     - For Smart UV Project: Set Island Margin to 0.02
     - Click OK

6. **Pack UV islands** (optional but recommended for space efficiency):
   - With all faces still selected in Edit Mode
   - In the UV editor (left panel), go to UV menu → Pack Islands
   - This arranges UV islands efficiently to minimize wasted space

### Step 2: Prepare the Baking Setup

1. **Switch to Shading workspace**:
   - Click on "Shading" tab at the top of Blender
   - You'll see the Shader Editor at the bottom

2. **Set up render engine**:
   - In Properties panel, click the camera icon (Render Properties)
   - At the very top, change "Render Engine" from Eevee to Cycles
   - Under "Device", select GPU Compute if you have a graphics card, otherwise keep it on CPU

3. **Create a target texture for each material**:
   - Select your first material in the material list (visible in Shader Editor)
   - In the Shader Editor, press Shift+A to add a node
   - Navigate to Texture → Image Texture
   - Click "New" in the Image Texture node
   - Settings for new image:
     - Name: "baked_texture" (or any descriptive name)
     - Width/Height: 2048 (2K resolution, use 4096 for more detail)
     - Color: Black (important!)
     - Check "32-bit Float" for better quality
   - Click OK to create

4. **Add this texture node to ALL materials**:
   - Right-click the Image Texture node you just created
   - Select "Copy" from the context menu
   - For each material in your model:
     - Select the material from the dropdown
     - Click in empty space in the Shader Editor to deselect everything
     - Press Ctrl+V to paste the texture node
     - Click on the pasted node to select it (it should be highlighted in white/orange)
     - DO NOT connect this node to anything - just leave it selected

**Important**: The texture node must be selected (highlighted) in each material for baking to work!

### Step 3: Configure Bake Settings

1. **Access Bake settings**:
   - In Properties panel, stay in Render Properties (camera icon)
   - Scroll down to find "Bake" section (near the bottom)
   - Click to expand it

2. **Configure bake type**:
   - Under "Bake Type", select "Diffuse"
   - IMPORTANT: Under "Influence", uncheck:
     - Direct (turn OFF)
     - Indirect (turn OFF)
   - Keep only "Color" checked
   - This ensures we only bake the texture colors, not lighting

3. **Set output target**:
   - Make sure "Target" is set to "Image Textures"
   - "Margin" can be set to 4-16 pixels (prevents seams)

### Step 4: Perform the Bake

1. **Start baking**:
   - Make sure your model is selected
   - Click the "Bake" button in the Bake panel
   - Wait for the process to complete (progress bar at bottom of window)
   - Time depends on model complexity and resolution

2. **Save the baked texture**:
   - Once baking is complete, go to UV Editing workspace
   - In the UV/Image Editor, you should see your baked texture
   - Go to Image menu → Save As
   - Save as PNG format (recommended for Recoil)
   - Choose a memorable location

### Step 5: Apply the Baked Texture

1. **Clean up the model**:
   - Go back to Shading workspace
   - In Object Data Properties (green triangle icon), find UV Maps
   - Delete the original UV map(s), keeping only your "baked" UV map
   - The remaining UV map will automatically become active

2. **Remove old materials**:
   - In Material Properties (sphere icon)
   - Select each material and click the "-" button to remove them all

3. **Create new single material**:
   - Click "+" to add a new material
   - Name it something like "baked_material"

4. **Apply the baked texture**:
   - In Shader Editor, add an Image Texture node (Shift+A → Texture → Image Texture)
   - Click "Open" in the node and load your saved baked texture
   - Connect the Color output to the Base Color input of the Principled BSDF

### Step 6: Verify and Export

1. **Check the result**:
   - Switch viewport shading to "Material Preview" (sphere icons at top right of 3D view)
   - Your model should now display with the single baked texture

2. **Export for Recoil**:
   - File → Export → glTF 2.0
   - Use settings as recommended in the Recoil documentation
   - The texture will be exported with the model

### Troubleshooting

- **Black spots on baked texture**: Your UV islands are overlapping. Redo the UV unwrap with better settings
- **Texture looks blurry**: Increase the resolution when creating the new texture (use 4096 instead of 2048)
- **Missing parts in bake**: Ensure the Image Texture node is selected in ALL materials before baking
- **Bake button is grayed out**: Make sure you're in Cycles render engine, not Eevee

### Tips for Recoil/Spring

- Spring prefers DDS format for final textures, but PNG works well for the workflow
- Keep texture dimensions as powers of 2 (512, 1024, 2048, 4096)
- For team-colored units, you'll need to set up the alpha channel separately (advanced topic)
- Test your model in-game to ensure textures display correctly

