extends Control

## MAIN MENU
# reference to scenemanger, set when initialized
var scene_manager
# reference to the 2 nodes.
@onready var howtoplay := $HowToPlay
@onready var mainmenu := $MainMenuTitle

# refernces to the buttons
@onready var start_button := $MainMenuTitle/MenuButtons/Start
@onready var howtoplay_button := $MainMenuTitle/MenuButtons/HowToPlay
@onready var quit_button := $MainMenuTitle/MenuButtons/Quit
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
	back_button.grab_focus() # Sets cursor to back button
	mainmenu.visible = false
	howtoplay.visible = true

## Stops the game when pressed
func _on_quit_pressed() -> void:
	get_tree().quit()

## Go back to main menu
func _on_back_pressed() -> void:
	howtoplay_button.grab_focus()
	mainmenu.visible = true
	howtoplay.visible = false
