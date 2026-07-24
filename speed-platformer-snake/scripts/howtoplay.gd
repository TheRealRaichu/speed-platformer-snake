extends Control
 
## HOW TO PLAY
signal back_pressed
 
var back_button: Button
 
func _ready() -> void:
	back_button = get_node("BackNode/back")
	back_button.pressed.connect(_on_back_pressed)
 
## Called by the main menu script right after this panel is shown.
func focus_back_button() -> void:
	back_button.grab_focus()
 
func _on_back_pressed() -> void:
	back_pressed.emit()