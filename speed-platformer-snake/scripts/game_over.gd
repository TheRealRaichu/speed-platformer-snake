extends Control
var scene_manager
var player

## GAME OVER SCREEN

# child reference
@onready var restart_button := $PanelContainer/VBoxContainer/Restart
@onready var quit_button := $PanelContainer/VBoxContainer/Quit

func _ready() -> void:
	restart_button.grab_focus() # restart button takes focus for key navigation

## Restarts game
func _on_restart_pressed() -> void:
	scene_manager.start_game()

## Quits to Main Menu
func _on_quit_pressed() -> void:
	scene_manager.main_menu()
