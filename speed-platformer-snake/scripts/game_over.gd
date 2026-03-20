extends Control
var scene_manager
var player

## GAME OVER SCREEN

# child reference
@onready var restart_button := $Restart
@onready var quit_button := $Quit
@onready var high_score_label := $"high score"

func _ready() -> void:
	display_score() # display score of game
	restart_button.grab_focus() # restart button takes focus for key navigation

func display_score():
	high_score_label.text = "Score: " + str(Globals.score)

## Restarts game
func _on_restart_pressed() -> void:
	scene_manager.start_game()

## Quits to Main Menu
func _on_quit_pressed() -> void:
	scene_manager.main_menu()
