#!/usr/bin/env python3
"""
Blender script to import Bricklink Studio LDraw models into Recoil/Spring S3O format
Based on IMPORT.md instructions
"""

import bpy
import math
import sys
from mathutils import Vector

# Parse command-line arguments (passed after --)
if "--" not in sys.argv:
    print("Error: No model name provided")
    print("Usage: blender --background --python blender_import_script.py -- <model_name>")
    sys.exit(1)

args = sys.argv[sys.argv.index("--") + 1:]
if len(args) < 1:
    print("Error: Model name required")
    print("Usage: blender --background --python blender_import_script.py -- <model_name>")
    sys.exit(1)

model_name = args[0]
ldraw_file = f"/home/pepijn/code/VroomRTS/contrib/{model_name}.ldr"
ldraw_library = "/home/pepijn/Games/bricklink-studio/drive_c/Program Files/Studio 2.0/ldraw"

print(f"Model name: {model_name}")
print(f"LDraw file: {ldraw_file}")

# Step 0: Clear the default scene
print("Clearing default scene...")
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

# Step 1: Import LDraw file
print(f"Importing LDraw file from {ldraw_file}...")
bpy.ops.import_scene.importldraw(
    filepath=ldraw_file,
    ldrawPath=ldraw_library,
    realScale=1000,
    resPrims='Low',
    addEnvironment=False,
    bevelEdges=False,
    curvedWalls=False
)
print("Import complete!")

# Step 2: Combine all mesh objects
print("Combining mesh objects...")
bpy.ops.object.select_all(action='DESELECT')
mesh_objects = []

for obj in bpy.data.objects:
    if obj.type == 'MESH':
        obj.select_set(True)
        mesh_objects.append(obj)

# Join all meshes
if mesh_objects:
    bpy.context.view_layer.objects.active = mesh_objects[0]
    bpy.ops.object.join()
    combined_mesh = bpy.context.active_object
    print(f"Combined {len(mesh_objects)} objects into: {combined_mesh.name}")

# Step 3: Merge vertices by distance
print("Merging vertices by distance...")
bpy.ops.object.mode_set(mode='EDIT')
bpy.ops.mesh.select_all(action='SELECT')
bpy.ops.mesh.remove_doubles()
bpy.ops.object.mode_set(mode='OBJECT')
print(f"Vertex count: {len(combined_mesh.data.vertices)}")

# Step 4: Calculate dimensions for S3O root
print("Calculating model dimensions...")
bbox_corners = [combined_mesh.matrix_world @ Vector(corner) for corner in combined_mesh.bound_box]

min_x = min(corner.x for corner in bbox_corners)
max_x = max(corner.x for corner in bbox_corners)
min_y = min(corner.y for corner in bbox_corners)
max_y = max(corner.y for corner in bbox_corners)
min_z = min(corner.z for corner in bbox_corners)
max_z = max(corner.z for corner in bbox_corners)

midpoint_x = (min_x + max_x) / 2
midpoint_y = (min_y + max_y) / 2
midpoint_z = (min_z + max_z) / 2

collision_radius = max(
    math.sqrt((corner.x - midpoint_x)**2 + (corner.y - midpoint_y)**2)
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

# Step 6: Parent the combined mesh to S3O root
print("Parenting mesh to S3O root...")
bpy.ops.object.select_all(action='DESELECT')
combined_mesh.select_set(True)
s3o_root.select_set(True)
bpy.context.view_layer.objects.active = s3o_root
bpy.ops.object.parent_set(type='OBJECT', keep_transform=True)
print(f"Parented to {s3o_root.name}")

# Step 7: Clean up empty objects left from joining
print("Cleaning up empty objects...")
empties_to_delete = []
for obj in bpy.data.objects:
    if obj.type == 'EMPTY':
        # Keep S3O root and its children
        if not (obj.name == model_name or obj.name.startswith(f"{model_name}.")):
            empties_to_delete.append(obj)

for obj in empties_to_delete:
    bpy.data.objects.remove(obj, do_unlink=True)
print(f"Deleted {len(empties_to_delete)} empty objects")

# Step 8: Create UV map
print("Creating UV map...")
bpy.context.view_layer.objects.active = combined_mesh
combined_mesh.select_set(True)
bpy.ops.object.mode_set(mode='EDIT')
bpy.ops.mesh.select_all(action='SELECT')
bpy.ops.uv.smart_project(angle_limit=66.0, island_margin=0.001)
print("UV map created using Smart UV Project")

# Step 9: Pack UV islands
print("Packing UV islands...")
bpy.ops.uv.pack_islands(margin=0.001)
bpy.ops.object.mode_set(mode='OBJECT')
print("UV islands packed")

# Step 10: Convert non-standard materials to Lego Standard (preserving colors)
print("Converting materials to Lego Standard (preserving colors)...")
lego_standard = bpy.data.node_groups.get("Lego Standard")
if lego_standard:
    for mat_slot in combined_mesh.material_slots:
        mat = mat_slot.material
        if mat and mat.use_nodes:
            nodes = mat.node_tree.nodes
            links = mat.node_tree.links

            group_node = None
            output_node = None
            old_color = None

            for node in nodes:
                if node.type == 'GROUP' and hasattr(node, 'node_tree'):
                    if node.node_tree.name not in ['Lego Standard', 'Slope Texture']:
                        group_node = node
                        old_color = tuple(node.inputs['Color'].default_value)
                elif node.type == 'OUTPUT_MATERIAL':
                    output_node = node

            if group_node and old_color:
                location = group_node.location
                nodes.remove(group_node)
                new_node = nodes.new('ShaderNodeGroup')
                new_node.node_tree = lego_standard
                new_node.location = location
                # Preserve the original color (including alpha)
                new_node.inputs['Color'].default_value = old_color
                if output_node and 'Shader' in new_node.outputs and 'Surface' in output_node.inputs:
                    links.new(new_node.outputs['Shader'], output_node.inputs['Surface'])

# Step 11: Switch to Cycles render engine
print("Setting up render engine for baking...")
bpy.context.scene.render.engine = 'CYCLES'

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

# Step 13: Add texture nodes for baking
print("Adding bake target texture nodes...")
special_materials = ["Material_38", "Material_42"]

for mat_slot in combined_mesh.material_slots:
    mat = mat_slot.material
    if mat and mat.use_nodes:
        nodes = mat.node_tree.nodes

        # Add single texture node for texture1 (will reuse for texture2)
        tex_node = nodes.new('ShaderNodeTexImage')
        tex_node.image = texture1
        tex_node.name = "BakeTarget"
        tex_node.location = (0, -400)
        nodes.active = tex_node

# Step 14: Configure bake settings
print("Configuring bake settings...")
bpy.context.scene.cycles.bake_type = 'DIFFUSE'
bpy.context.scene.render.bake.use_pass_direct = False
bpy.context.scene.render.bake.use_pass_indirect = False
bpy.context.scene.render.bake.use_pass_color = True
bpy.context.scene.render.bake.margin = 16

# Step 15: Perform first bake (all materials to texture1)
print("Baking first texture (this may take a while)...")

# Make sure we're in object mode
if bpy.context.object and bpy.context.object.mode != 'OBJECT':
    bpy.ops.object.mode_set(mode='OBJECT')

# Update the scene to ensure all changes are applied
bpy.context.view_layer.update()

# Select and set active
bpy.context.view_layer.objects.active = combined_mesh
bpy.ops.object.select_all(action='DESELECT')
combined_mesh.select_set(True)

# Bake
bpy.ops.object.bake(type='DIFFUSE')
print("First bake complete!")

# TEMPORARY: Exit here to inspect the result
print("Saving textures...")
texture1.file_format = 'PNG'
texture1.filepath_raw = f"/home/pepijn/code/VroomRTS/contrib/{model_name}.png"
texture1.save()
print(f"  Saved: contrib/{model_name}.png")
# blend_file_path = f"/home/pepijn/code/VroomRTS/contrib/{model_name}.blend"
# bpy.ops.wm.save_as_mainfile(filepath=blend_file_path)
# print(f"  Saved: contrib/{model_name}.blend")
# import sys
# print("Stopping for inspection. Remove the sys.exit() to continue.")
# sys.exit(0)

# Step 16: Switch special materials to red emission for texture2
print("Setting up second texture bake...")
for mat_slot in combined_mesh.material_slots:
    mat = mat_slot.material
    if mat and mat.use_nodes:
        nodes = mat.node_tree.nodes

        if mat.name in special_materials:
            # Find the Lego Standard node and texture node
            lego_standard = None
            bake_target = None

            for node in nodes:
                if node.type == 'GROUP' and hasattr(node, 'node_tree') and node.node_tree.name == 'Lego Standard':
                    lego_standard = node
                elif node.name == 'BakeTarget':
                    bake_target = node

            if lego_standard and bake_target:
                # Change to red color for emission
                lego_standard.inputs['Color'].default_value = (0.5, 0, 0, 1)
                # Change texture to texture2
                bake_target.image = texture2
                # Make sure it's active
                nodes.active = bake_target
        else:
            # Deactivate texture nodes for non-special materials
            nodes.active = None

# Step 17: Perform second bake (special materials to texture2)
print("Baking second texture (this may take a while)...")
bpy.ops.object.bake(type='DIFFUSE')
print("Second bake complete!")

# Step 18: Save both textures

texture2.file_format = 'PNG'
texture2.filepath_raw = f"/home/pepijn/code/VroomRTS/contrib/{model_name}2.png"
texture2.save()
print(f"  Saved: contrib/{model_name}2.png")

# Step 19: Export S3O model
print("Exporting S3O model...")
s3o_export_path = f"/home/pepijn/code/VroomRTS/Objects3d/{model_name}.s3o"
bpy.context.view_layer.objects.active = s3o_root
bpy.ops.object.select_all(action='DESELECT')
s3o_root.select_set(True)
bpy.ops.s3o_tools.export_s3o(filepath=s3o_export_path)
print(f"  Exported: Objects3d/{model_name}.s3o")

# Step 20: Save Blender file for inspection
blend_file_path = f"/home/pepijn/code/VroomRTS/contrib/{model_name}.blend"
bpy.ops.wm.save_as_mainfile(filepath=blend_file_path)
print(f"  Saved: contrib/{model_name}.blend")

print("Model import, texture baking, and S3O export complete!")
