extends Control

## MAIN MENU
# reference to scenemanger, set when initialized
var scene_manager
# reference to the 2 nodes.
@onready var howtoplay := $HowToPlay
@onready var mainmenu := $MainMenuTitle

# refernces to the buttons
@onready var start_button := $MainMenuTitle/VBoxContainer/Start
@onready var howtoplay_button := $MainMenuTitle/VBoxContainer/HowToPlay
@onready var quit_button := $MainMenuTitle/VBoxContainer/Quit
@onready var back_button := $HowToPlay/back


## Initialize the main menu as true and How To Play section as false when first time running, and initilizaed cursor as false.
func _ready() -> void:
	start_button.grab_focus() # start button takes focus for key navigation as the first

	mainmenu.visible = true
	howtoplay.visible = false

## Starts the game when pressed
func _on_start_pressed() -> void:
	scene_manager.start_game()

## Goes to the How to play section inside of main menu scene through turn on and off nodes.
func _on_how_to_play_pressed() -> void:
	mainmenu.visible = false
	howtoplay.visible = true
	back_button.grab_focus() # Sets cursor to back button

## Stops the game when pressed
func _on_quit_pressed() -> void:
	get_tree().quit()

## Go back to main menu
func _on_back_pressed() -> void:
	howtoplay_button.grab_focus()
	mainmenu.visible = true
	howtoplay.visible = false
