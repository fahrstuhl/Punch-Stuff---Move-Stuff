tool
extends Sprite3D

export(String, MULTILINE) var text = "text" setget set_text
export(Vector2) var size = Vector2(100, 100) setget set_size

func _ready():
	refresh_text()
	refresh_size()
	texture = $Viewport.get_texture()

func refresh_text():
	$Viewport/RichTextLabel.bbcode_text = text

func refresh_size():
	$Viewport.size = size

func set_text(new_text):
	text = new_text
	if Engine.editor_hint:
		refresh_text()

func set_size(new_size):
	size = new_size
	if Engine.editor_hint:
		refresh_size()
