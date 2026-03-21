class_name UIText
extends TextureRect

## UI TEXT

# exports
@export var focused_image : Texture2D
@export var unfocused_image : Texture2D

# switch image on call
func focused() -> void:
	texture = focused_image
func unfocused() -> void:
	texture = unfocused_image
