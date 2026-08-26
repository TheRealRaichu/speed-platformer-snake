extends Control

## HOW TO PLAY

var scene_manager : SceneManager
# exports
@export var back : Button

## return to main menu
func _on_back_pressed() -> void:
	scene_manager.main_menu()

# add tutorial button
