extends Control

## MAIN MENU
# reference to scenemanger, set when initialized
var scene_manager

func _on_start_game_pressed() -> void:
	scene_manager.start_game()


func _on_quit_game_pressed() -> void:
	get_tree().quit()
