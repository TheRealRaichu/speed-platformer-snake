class_name UIButton
extends TextureButton

## MENU BUTTON

@onready var cursor := $Cursor

func _ready() -> void:
	cursor.modhide() # hide via modulate

func _on_pressed() -> void:
	#AudioManager.play("select") # play menu select noise
	pass

func _on_focus_entered() -> void:
	cursor.modshow()

func _on_focus_exited():
	cursor.modhide()
