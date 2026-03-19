extends Node2D
var scene_manager

func resume(): # We call it continue, but only works with the name of "resume"
	get_tree().paused = false

func pause():
	get_tree().paused = true

# Stop movement of the scarf temporarily
## Continue the game
func _on_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()

## Restart game by going to main menu
func _on_restart_pressed() -> void:
	if scene_manager:
		get_tree().paused = false
		scene_manager.switch_scene(scene_manager.SCENES.get("main_menu"))

## Quits the game
func _on_quit_pressed() -> void: 
	get_tree().quit()
