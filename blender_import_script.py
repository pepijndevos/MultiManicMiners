#!/usr/bin/env python3
"""
Blender script to import Bricklink Studio LDraw models into Recoil/Spring S3O format
Based on IMPORT.md instructions
"""

import bpy
import math
from mathutils import Vector

model_name = "PowerStation"
ldraw_file = "/home/pepijn/code/VroomRTS/contrib/PowerStation.ldr"
ldraw_library = "/home/pepijn/Games/bricklink-studio/drive_c/Program Files/Studio 2.0/ldraw"

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

print("Model import complete!")
