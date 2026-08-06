extends Control
var scene_manager
var player

## GAME OVER SCREEN

# child reference
@onready var restart_button := $PanelContainer/VBoxContainer/RestartNode/Restart
@onready var cursor_restart := $PanelContainer/VBoxContainer/RestartNode/RestartCursor
@onready var try_again_text := $PanelContainer/VBoxContainer/RestartNode/TryAgainText
@onready var quit_button := $PanelContainer/VBoxContainer/QuitNode/Quit
@onready var cursor_quit := $PanelContainer/VBoxContainer/QuitNode/QuitCursor
@onready var quit_text := $PanelContainer/VBoxContainer/QuitNode/QuitText
@onready var score_label := $ScoreLabel

func _ready() -> void:
	display_score() # display score of game
	restart_button.grab_focus() # restart button takes focus for key navigation
	cursor_quit.visible = false

func display_score():
	score_label.text = "days survived: " + str(Globals.score - 1)

## Restarts game
func _on_restart_pressed() -> void:
	scene_manager.restart_current_mode()

func _on_restart_focus_entered() -> void:
	cursor_restart.visible = true
	try_again_text.focused()

func _on_restart_focus_exited() -> void:
	cursor_restart.visible = false
	try_again_text.unfocused()


## Quits to Main Menu
func _on_quit_pressed() -> void:
	scene_manager.main_menu()

func _on_quit_focus_entered() -> void:
	cursor_quit.visible = true
	quit_text.focused()

func _on_quit_focus_exited() -> void:
	cursor_quit.visible = false
	quit_text.unfocused()
