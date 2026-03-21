extends Control

## MAIN MENU
# reference to scenemanger, set when initialized
var scene_manager
@onready var howtoplay := $HowToPlay
@onready var mainmenu := $MainMenuTitle

## Initialize the main menu as true and How To Play section as false when first time running
func _ready() -> void:
	mainmenu.visible = true
	howtoplay.visible = false

## Starts the game when pressed
func _on_start_game_pressed() -> void:
	scene_manager.start_game()

## Stops the game when pressed
func _on_quit_game_pressed() -> void:
	get_tree().quit()

## Goes to the How to play section inside of main menu scene through turn on and off nodes.
func _on_howtoplay_game_pressed() -> void:
	mainmenu.visible = false
	howtoplay.visible = true
	
## Go back to main menu
func _on_back_pressed() -> void:
	mainmenu.visible = true
	howtoplay.visible = false
