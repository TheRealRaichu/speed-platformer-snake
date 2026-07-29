class_name UIButton
extends Button

## MENU BUTTON

@onready var cursor := $HBoxContainer/Cursor
@onready var uitext := $HBoxContainer/Text

# exports
@export var focused_texture : Texture2D
@export var unfocused_texture : Texture2D

func _ready() -> void:
	cursor.modhide() # hide via modulate
	uitext.focused_image = focused_texture # set textures
	uitext.unfocused_image = unfocused_texture
	uitext.unfocused()

func _on_pressed() -> void:
	#AudioManager.play("select") # play menu select noise
	pass

func _on_focus_entered() -> void:
	#AudioManager.play("navigation") # play menu nav noise
	uitext.focused() # set ui text status
	cursor.modshow()

func _on_focus_exited():
	uitext.unfocused()
	cursor.modhide()
