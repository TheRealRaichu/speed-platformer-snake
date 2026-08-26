extends Control

## MAIN MENU
# reference to scenemanger, set when initialized
var scene_manager

# refernces to the buttons
@export var start_button : UIButton
@export var howtoplay_button : UIButton
@export var quit_button : UIButton

@export var menu_buttons : VBoxContainer


## Initialize the main menu as true and How To Play section as false when first time running, and initilizaed cursor as false.
func _ready() -> void:
	start_button.grab_focus() # start button takes focus for key navigation as the first

## Starts the game when pressed
func _on_start_pressed() -> void:
	scene_manager.start_game()

## Goes to the How to play section inside of main menu scene through turn on and off nodes.
func _on_how_to_play_pressed() -> void:
	pass
	scene_manager.how_to_play()

## Stops the game when pressed
func _on_quit_pressed() -> void:
	get_tree().quit()
