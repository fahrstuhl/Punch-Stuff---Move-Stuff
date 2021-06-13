tool
extends Spatial

signal collided_with_player(normal)

export(int, 2, 1000) var width = 2 setget set_width
export(int, 2, 1000) var height = 2 setget set_height
export(SpatialMaterial) var material = preload("res://white.material") setget set_material

func _ready():
	resize()
	apply_material()

func set_width(new_width):
	width = clamp(new_width, 2, 1000)
	if Engine.editor_hint:
		resize()

func set_height(new_height):
	height = clamp(new_height, 2, 1000)
	if Engine.editor_hint:
		resize()

func resize():
	$MeshInstance.mesh.size = Vector3(width, height, 2)
	$CollisionShape.shape.set_extents(Vector3(width/2, height/2, 1))

func apply_material():
	$MeshInstance.set_surface_material(0, material)

func collided_with_player(normal):
	emit_signal("collided_with_player", normal)

func set_material(new_material):
	material = new_material
	if Engine.editor_hint:
		apply_material()
