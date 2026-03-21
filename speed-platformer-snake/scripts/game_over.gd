extends Control
var scene_manager
var player

## GAME OVER SCREEN

# child reference
@onready var restart_button := $PanelContainer/VBoxContainer/Restart
@onready var quit_button := $PanelContainer/VBoxContainer/Quit
@onready var cursor_restart := $Cursor_1
@onready var cursor_quit := $Cursor_2

func _ready() -> void:
	restart_button.grab_focus() # restart button takes focus for key navigation
	cursor_quit.visible = false

## Restarts game
func _on_restart_pressed() -> void:
	scene_manager.start_game()

func _on_restart_focus_entered() -> void:
	cursor_restart.visible = true

func _on_restart_focus_exited() -> void:
	cursor_restart.visible = false


## Quits to Main Menu
func _on_quit_pressed() -> void:
	scene_manager.main_menu()

func _on_quit_focus_entered() -> void:
	cursor_quit.visible = true

func _on_quit_focus_exited() -> void:
	cursor_quit.visible = false


