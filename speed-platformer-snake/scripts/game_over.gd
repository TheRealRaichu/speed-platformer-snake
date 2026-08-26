extends Control
var scene_manager
var player

## GAME OVER SCREEN

# child reference
@export var restart_button : UIButton
@export var quit_button : UIButton
@export var score_label : Label

func _ready() -> void:
	display_score() # display score of game
	restart_button.grab_focus() # restart button takes focus for key navigation

func display_score():
	score_label.text = "days survived: " + str(Globals.score - 1)

## Restarts game
func _on_try_again_pressed() -> void:
	scene_manager.start_game()

## Quits to Main Menu
func _on_quit_pressed() -> void:
	scene_manager.main_menu()
