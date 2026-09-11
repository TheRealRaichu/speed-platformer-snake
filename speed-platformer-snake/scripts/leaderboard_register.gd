extends Control
class_name LeaderboardRegister

@export var entry_field : HBoxContainer
signal name_confirm

func _ready() -> void:
	# first field gets focus
	entry_field.get_child(0).grab_focus()

func attempt_confirm_name():
	var name := ""
	for child in entry_field.get_children():
		name += child.current_letter
	if name.strip_edges() != "": # finish only if valid name
		name_confirm.emit(name)
		die()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		attempt_confirm_name()

func die():
	queue_free()
