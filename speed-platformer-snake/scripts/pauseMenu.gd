extends Node2D
var scene_manager
var player

func resume(): # We call it continue, but only works with the name of "resume"
	if player:
		player.scarf_pause(false)
	get_tree().paused = false

# Get Reference to scarf and pause the scarg movement temporarily
func pause():
	if player:
		player.scarf_pause(true)
	get_tree().paused = true

## Continue the game
func _on_continue_pressed() -> void:
	if player:
		player.scarf_pause(false)
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
