extends Control

## MAIN MENU
# child ref
@onready var start_button := $"start game"
@onready var how_to_play_button := $"how to play"
@onready var quit_game_button := $"quit game"

# reference to scenemanger, set when initialized
var scene_manager

func _ready() -> void:
	start_button.grab_focus()

func _on_start_game_pressed() -> void:
	scene_manager.start_game()

func _on_how_to_play_pressed() -> void:
	pass # Replace with function body.

func _on_quit_game_pressed() -> void:
	get_tree().quit()
