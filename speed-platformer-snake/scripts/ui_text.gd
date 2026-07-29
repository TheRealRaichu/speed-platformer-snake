class_name UIText
extends TextureRect

## UI TEXT

var focused_image : Texture2D
var unfocused_image : Texture2D

# switch image on call
func focused() -> void:
	texture = focused_image
func unfocused() -> void:
	texture = unfocused_image
