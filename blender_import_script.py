#!/usr/bin/env python3
"""
Blender script to import Bricklink Studio LDraw models into Recoil/Spring S3O format
Uses the import_scene.importldr operator (modern LDraw plugin)
Based on IMPORT.md instructions
"""

import bpy
import math
import sys
import os
from mathutils import Vector

# Parse command-line arguments (passed after --)
if "--" not in sys.argv:
    print("Error: No LDraw file path provided")
    print("Usage: blender --background --python blender_import_script.py -- <path/to/file.ldr>")
    sys.exit(1)

args = sys.argv[sys.argv.index("--") + 1:]
if len(args) < 1:
    print("Error: LDraw file path required")
    print("Usage: blender --background --python blender_import_script.py -- <path/to/file.ldr>")
    sys.exit(1)

# Get full path to LDraw file
ldraw_file = os.path.abspath(args[0])

# Extract model name from filename (without extension)
model_name = os.path.splitext(os.path.basename(ldraw_file))[0]

# Get script directory
script_dir = os.path.dirname(os.path.abspath(__file__))

# LDraw library path - check environment variable or use default Lutris path
ldraw_library = os.environ.get('LDRAW_LIBRARY') or os.path.expanduser("~/Games/bricklink-studio/drive_c/Program Files/Studio 2.0/ldraw")

print(f"Model name: {model_name}")
print(f"LDraw file: {ldraw_file}")
print(f"LDraw library: {ldraw_library}")

# Step 0: Clear the default scene
print("Clearing default scene...")
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

# Step 1: Import LDraw file
print(f"Importing LDraw file from {ldraw_file}...")
bpy.ops.import_scene.importldr(
    filepath=ldraw_file,
    ldraw_path=ldraw_library,
    scene_scale=0.4,
    instance_type='LinkedDuplicates',
    stud_type='Normal',
    primitive_resolution='Low',
    add_gap_between_parts=False
)
print("Import complete!")

# Step 2: Combine mesh objects while preserving hierarchy
print("Combining mesh objects while preserving hierarchy...")

# Step 2a: Make all meshes single-user to avoid LinkedDuplicates issues
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        obj.data = obj.data.copy()

# Step 2b: Find the root empty and any sub-empties (like turret pivots)
root_empty = None
for obj in bpy.data.objects:
    if obj.type == 'EMPTY' and obj.parent is None:
        root_empty = obj
        break

if not root_empty:
    print("Warning: No root empty found, combining all meshes into one")
    # Fallback: combine everything
    mesh_objects = [obj for obj in bpy.data.objects if obj.type == 'MESH']
    if mesh_objects:
        bpy.ops.object.select_all(action='DESELECT')
        for obj in mesh_objects:
            obj.select_set(True)
        bpy.context.view_layer.objects.active = mesh_objects[0]
        bpy.ops.object.join()
        combined_mesh = bpy.context.active_object
        combined_mesh.name = "Base"
        print(f"Combined {len(mesh_objects)} objects into: {combined_mesh.name}")
else:
    print(f"Found root: {root_empty.name}")

    # Step 2c: Find sub-empties (turret pivots, etc.) that should remain separate pieces
    sub_empties = [child for child in root_empty.children if child.type == 'EMPTY']

    # Step 2d: Combine base meshes (direct mesh children of root)
    base_meshes = [child for child in root_empty.children if child.type == 'MESH']
    print(f"Found {len(base_meshes)} base mesh parts")

    if base_meshes:
        bpy.ops.object.select_all(action='DESELECT')
        for obj in base_meshes:
            obj.select_set(True)
        bpy.context.view_layer.objects.active = base_meshes[0]
        bpy.ops.object.join()
        combined_mesh = bpy.context.active_object
        combined_mesh.name = "Base"
        print(f"  Combined into 'Base': {len(combined_mesh.data.vertices)} vertices")
    else:
        combined_mesh = None

    # Step 2e: Combine meshes within each sub-empty (preserving the pivot empties)
    for sub_empty in sub_empties:
        sub_meshes = [child for child in sub_empty.children if child.type == 'MESH']
        print(f"Found {len(sub_meshes)} mesh parts under '{sub_empty.name}'")

        if sub_meshes:
            bpy.ops.object.select_all(action='DESELECT')
            for obj in sub_meshes:
                obj.select_set(True)
            bpy.context.view_layer.objects.active = sub_meshes[0]
            bpy.ops.object.join()
            sub_combined = bpy.context.active_object
            # Keep the name matching the empty's name for Spring unit scripts
            sub_combined.name = sub_empty.name.replace('.io', '')
            print(f"  Combined into '{sub_combined.name}': {len(sub_combined.data.vertices)} vertices")

print("Mesh combining complete!")

# Step 2.5: Render thumbnail for UI
print("Rendering thumbnail...")

# Ensure UnitPics directory exists
unitpics_dir = os.path.join(script_dir, "MultiManicMiners", "UnitPics")
os.makedirs(unitpics_dir, exist_ok=True)

# Get bounding box for camera positioning (calculate from all mesh objects)
bbox_corners = []
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        bbox_corners.extend([obj.matrix_world @ Vector(corner) for corner in obj.bound_box])
min_x = min(corner.x for corner in bbox_corners)
max_x = max(corner.x for corner in bbox_corners)
min_y = min(corner.y for corner in bbox_corners)
max_y = max(corner.y for corner in bbox_corners)
min_z = min(corner.z for corner in bbox_corners)
max_z = max(corner.z for corner in bbox_corners)

center_x = (min_x + max_x) / 2
center_y = (min_y + max_y) / 2
center_z = (min_z + max_z) / 2

# Calculate model size for camera distance
model_size = max(max_x - min_x, max_y - min_y, max_z - min_z)

# Create camera
cam_data = bpy.data.cameras.new("ThumbnailCamera")
cam_obj = bpy.data.objects.new("ThumbnailCamera", cam_data)
bpy.context.scene.collection.objects.link(cam_obj)

# Position camera at 45 degree angle looking down at model
camera_distance = model_size * 2.5
cam_obj.location = (
    center_x + camera_distance * 0.7,
    center_y - camera_distance * 0.7,
    center_z + camera_distance * 0.5
)

# Point camera at model center
direction = Vector((center_x - cam_obj.location.x, center_y - cam_obj.location.y, center_z - cam_obj.location.z))
rot_quat = direction.to_track_quat('-Z', 'Y')
cam_obj.rotation_euler = rot_quat.to_euler()

# Set as active camera
bpy.context.scene.camera = cam_obj

# Add lighting
sun = bpy.data.lights.new(name="ThumbnailSun", type='SUN')
sun_obj = bpy.data.objects.new("ThumbnailSun", sun)
bpy.context.scene.collection.objects.link(sun_obj)
sun_obj.location = (center_x, center_y, center_z + model_size * 2)
sun_obj.rotation_euler = (math.radians(45), 0, math.radians(45))
sun.energy = 2.0

# Configure render settings for thumbnail
bpy.context.scene.render.resolution_x = 512
bpy.context.scene.render.resolution_y = 512
bpy.context.scene.render.image_settings.file_format = 'PNG'
bpy.context.scene.render.film_transparent = True

# Render
thumbnail_path = f"{unitpics_dir}/{model_name}.png"
bpy.context.scene.render.filepath = thumbnail_path
bpy.ops.render.render(write_still=True)

print(f"  Saved thumbnail: MultiManicMiners/UnitPics/{model_name}.png")

# Clean up render objects
bpy.data.objects.remove(cam_obj, do_unlink=True)
bpy.data.objects.remove(sun_obj, do_unlink=True)
bpy.data.cameras.remove(cam_data, do_unlink=True)
bpy.data.lights.remove(sun, do_unlink=True)

# Step 3: Merge vertices by distance and apply flat shading
print("Merging vertices by distance...")
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.select_all(action='SELECT')
        bpy.ops.mesh.remove_doubles()
        bpy.ops.mesh.faces_shade_flat()
        bpy.ops.object.mode_set(mode='OBJECT')
        print(f"  {obj.name}: {len(obj.data.vertices)} vertices")

# Step 4: Calculate dimensions for S3O root
print("Calculating model dimensions...")
# Calculate from all mesh objects
bbox_corners = []
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        bbox_corners.extend([obj.matrix_world @ Vector(corner) for corner in obj.bound_box])

min_x = min(corner.x for corner in bbox_corners)
max_x = max(corner.x for corner in bbox_corners)
min_y = min(corner.y for corner in bbox_corners)
max_y = max(corner.y for corner in bbox_corners)
min_z = min(corner.z for corner in bbox_corners)
max_z = max(corner.z for corner in bbox_corners)

midpoint_x = (min_x + max_x) / 2
midpoint_y = (min_y + max_y) / 2
midpoint_z = (min_z + max_z) / 2

# Calculate 3D collision radius (sphere encompassing entire model)
collision_radius = max(
    math.sqrt((corner.x - midpoint_x)**2 + (corner.y - midpoint_y)**2 + (corner.z - midpoint_z)**2)
    for corner in bbox_corners
)

height = max_z - min_z

print(f"  collision_radius: {collision_radius:.2f}")
print(f"  height: {height:.2f}")
print(f"  midpoint: ({midpoint_x:.2f}, {midpoint_y:.2f}, {midpoint_z:.2f})")

# Step 5: Create S3O root with calculated parameters
print(f"Adding S3O root for {model_name}...")
bpy.ops.s3o_tools.add_s3o_root(
    name=model_name,
    collision_radius=collision_radius,
    height=height,
    midpoint=(midpoint_x, midpoint_z, midpoint_y),  # S3O uses (X, Z, Y) order
    texture_name_1=f"{model_name}.dds",
    texture_name_2=f"{model_name}2.dds"
)
s3o_root = bpy.data.objects.get(model_name)

# Step 6: Re-parent model pieces to S3O root (preserving transforms)
print("Parenting model pieces to S3O root...")

# Find the LDraw root (MiningLaser.io or similar)
ldraw_root = None
for obj in bpy.data.objects:
    if obj.type == 'EMPTY' and obj.parent is None and obj != s3o_root:
        ldraw_root = obj
        break

if ldraw_root:
    # Store world matrix before reparenting
    world_matrix = ldraw_root.matrix_world.copy()

    # Parent the entire LDraw root under the S3O root
    ldraw_root.parent = s3o_root

    # Restore world matrix (which updates local matrix automatically)
    ldraw_root.matrix_world = world_matrix

    # CRITICAL: Mark EMPTYs with mesh descendants as non-placeholder pieces for S3O export
    # Without s3o_empty_type=1, EMPTYs are treated as placeholders and ignored!
    def has_mesh_descendant(obj):
        """Check if object has any mesh descendants (children, grandchildren, etc.)"""
        if obj.type == 'MESH':
            return True
        for child in obj.children:
            if has_mesh_descendant(child):
                return True
        return False

    def mark_empties_recursive(obj):
        """Recursively mark EMPTYs that have mesh descendants as structural pieces"""
        if obj.type == 'EMPTY' and has_mesh_descendant(obj):
            obj.s3o_empty_type = 'AIM_POINT'
            bpy.context.view_layer.update()
            if 's3o_root' in obj:
                del obj['s3o_root']
            print(f"  Marked {obj.name} as structural piece (s3o_empty_type='AIM_POINT')")
        # Recurse to children
        for child in obj.children:
            mark_empties_recursive(child)

    mark_empties_recursive(ldraw_root)
    print(f"  Parented {ldraw_root.name} to {s3o_root.name}")

# Step 8: Create UV maps for each mesh
print("Creating UV maps...")
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.select_all(action='SELECT')
        # Use Cube Projection for boxy Lego models - projects from 6 orthogonal directions
        bpy.ops.uv.cube_project(cube_size=1.0, correct_aspect=True, clip_to_bounds=False, scale_to_bounds=False)
        bpy.ops.object.mode_set(mode='OBJECT')
        print(f"  {obj.name}: UV map created")

# Step 9: Pack all UV islands together into shared texture space
print("Packing UV islands from all meshes...")
mesh_objects = [obj for obj in bpy.data.objects if obj.type == 'MESH']
bpy.ops.object.select_all(action='DESELECT')
for obj in mesh_objects:
    obj.select_set(True)

if mesh_objects:
    bpy.context.view_layer.objects.active = mesh_objects[0]
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.uv.pack_islands(margin=0.001, rotate=True)
    bpy.ops.object.mode_set(mode='OBJECT')
    print(f"Packed {len(mesh_objects)} meshes into shared UV space")

# Step 10: Switch to Cycles render engine
print("Setting up render engine for baking...")
bpy.context.scene.render.engine = 'CYCLES'
bpy.context.scene.cycles.device = 'CPU'
#bpy.context.scene.cycles.device = 'GPU'

texture_size = 4096
#texture_size = 1024  # For testing, use smaller size first

# Step 12: Create both texture images (4K)
print("Creating texture images (4096x4096)...")
texture1 = bpy.data.images.new(
    name="baked_texture",
    width=texture_size,
    height=texture_size,
    alpha=True,
    float_buffer=False
)
texture1.generated_color = (0, 0, 0, 1)

texture2 = bpy.data.images.new(
    name="baked_texture2",
    width=texture_size,
    height=texture_size,
    alpha=True,
    float_buffer=False
)
texture2.generated_color = (0, 0, 0, 1)

# Step 13: Add TWO texture nodes for baking to all materials
print("Adding bake target texture nodes...")
special_materials = ["38 Trans-Neon Orange", "42 Trans-Neon Green"]

for obj in bpy.data.objects:
    if obj.type != 'MESH':
        continue
    for mat_slot in obj.material_slots:
        mat = mat_slot.material
        if mat and mat.use_nodes:
            nodes = mat.node_tree.nodes

            # Add BakeTarget1 for texture1 (color)
            tex_node1 = nodes.new('ShaderNodeTexImage')
            tex_node1.image = texture1
            tex_node1.name = "BakeTarget1"
            tex_node1.location = (0, -400)

            # Add BakeTarget2 for texture2 (glow)
            tex_node2 = nodes.new('ShaderNodeTexImage')
            tex_node2.image = texture2
            tex_node2.name = "BakeTarget2"
            tex_node2.location = (0, -600)

            # Set BakeTarget1 as active for first bake
            nodes.active = tex_node1

# Step 14: Configure bake settings
print("Configuring bake settings...")
bpy.context.scene.cycles.bake_type = 'DIFFUSE'
bpy.context.scene.render.bake.use_pass_direct = False
bpy.context.scene.render.bake.use_pass_indirect = False
bpy.context.scene.render.bake.use_pass_color = True
bpy.context.scene.render.bake.margin = 16

# Step 14.5: Disable transmission and subsurface for diffuse bake (to get true base colors)
print("Disabling transmission and subsurface for diffuse bake...")
for mat in bpy.data.materials:
    if mat and mat.use_nodes:
        for node in mat.node_tree.nodes:
            if node.type == 'BSDF_PRINCIPLED':
                if node.inputs['Transmission Weight'].default_value > 0:
                    changed = f"transmission {node.inputs['Transmission Weight'].default_value} -> 0.0"
                    node.inputs['Transmission Weight'].default_value = 0.0
                    print(f"  {mat.name}: {changed}")

# Step 15: Perform first bake (all meshes to texture1)
print("Baking first texture (this may take a while)...")

# Make sure we're in object mode
if bpy.context.object and bpy.context.object.mode != 'OBJECT':
    bpy.ops.object.mode_set(mode='OBJECT')

# Update the scene to ensure all changes are applied
bpy.context.view_layer.update()

# Select all mesh objects for baking
mesh_objects = [obj for obj in bpy.data.objects if obj.type == 'MESH']
bpy.ops.object.select_all(action='DESELECT')
for obj in mesh_objects:
    obj.select_set(True)

if mesh_objects:
    bpy.context.view_layer.objects.active = mesh_objects[0]

# Bake all selected meshes
bpy.ops.object.bake(type='DIFFUSE')
print("First bake complete!")

# TEMPORARY: Exit here to inspect the result
print("Saving textures...")
texture1.file_format = 'PNG'
texture1.filepath_raw = os.path.join(script_dir, "contrib", f"{model_name}.png")
texture1.save()
print(f"  Saved: contrib/{model_name}.png")
# blend_file_path = os.path.join(script_dir, "contrib", f"{model_name}.blend")
# bpy.ops.wm.save_as_mainfile(filepath=blend_file_path)
# print(f"  Saved: contrib/{model_name}.blend")
# import sys
# print("Stopping for inspection. Remove the sys.exit() to continue.")
# sys.exit(0)

# Step 16: Set up emission on special materials and switch to BakeTarget2
print("Setting up second texture bake (glow map)...")
for obj in bpy.data.objects:
    if obj.type != 'MESH':
        continue
    for mat_slot in obj.material_slots:
        mat = mat_slot.material
        if mat and mat.use_nodes:
            nodes = mat.node_tree.nodes

            # Find BakeTarget2 and activate it
            bake_target2 = None
            for node in nodes:
                if node.name == 'BakeTarget2':
                    bake_target2 = node
                    nodes.active = node
                    break

            # For special materials, set red emission
            if mat.name in special_materials:
                for node in nodes:
                    if node.type == 'BSDF_PRINCIPLED':
                        # Set red emission for glow map (R channel = glow in Spring)
                        node.inputs['Emission Color'].default_value = (0.5, 0.0, 0.0, 1.0)
                        node.inputs['Emission Strength'].default_value = 1.0
                        print(f"  Set emission on: {mat.name}")
                        break
            # Non-special materials will bake black to texture2 (no emission)

# Step 17: Perform second bake (EMIT type for glow map)
print("Baking second texture (this may take a while)...")
bpy.context.scene.cycles.bake_type = 'EMIT'
bpy.ops.object.bake(type='EMIT')
print("Second bake complete!")

# Step 18: Save both textures

texture2.file_format = 'PNG'
texture2.filepath_raw = os.path.join(script_dir, "contrib", f"{model_name}2.png")
texture2.save()
print(f"  Saved: contrib/{model_name}2.png")

# Step 19: Export S3O model
print("Exporting S3O model...")
s3o_export_path = os.path.join(script_dir, "MultiManicMiners", "Objects3d", f"{model_name}.s3o")
bpy.context.view_layer.objects.active = s3o_root
bpy.ops.object.select_all(action='DESELECT')
s3o_root.select_set(True)
bpy.ops.s3o_tools.export_s3o(filepath=s3o_export_path)
print(f"  Exported: MultiManicMiners/Objects3d/{model_name}.s3o")

# Step 20: Save Blender file for inspection
blend_file_path = os.path.join(script_dir, "contrib", f"{model_name}.blend")
bpy.ops.wm.save_as_mainfile(filepath=blend_file_path)
print(f"  Saved: contrib/{model_name}.blend")

print("Model import, texture baking, and S3O export complete!")
