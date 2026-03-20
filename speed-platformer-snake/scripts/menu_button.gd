class_name UIButton
extends Button

## MENU BUTTON

@export var focused_texture : Texture2D
@export var unfocused_texture : Texture2D

func _on_pressed() -> void:
	AudioManager.play("select") # play menu select noise

func _on_focus_entered() -> void:
	AudioManager.play("navigation") # play menu nav noise
	# switch to focused texture

func _on_focus_exited() -> void:
	# switch to unfocused texture
	pass
