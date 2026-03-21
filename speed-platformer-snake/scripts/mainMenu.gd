extends Control

## MAIN MENU
# reference to scenemanger, set when initialized
var scene_manager
# reference to the 2 nodes.
@onready var howtoplay := $HowToPlay
@onready var mainmenu := $MainMenuTitle

# references to the cursor images
@onready var cursor_start := $MainMenuTitle/Cursor_1
@onready var cursor_htp := $MainMenuTitle/Cursor_2
@onready var cursor_quit := $MainMenuTitle/Cursor_3
@onready var cursor_back := $HowToPlay/Cursor_4

# refernces to the buttons
@onready var start_button := $"MainMenuTitle/start game"
@onready var howtoplay_button := $"MainMenuTitle/howtoplay game"
@onready var quit_button := $"MainMenuTitle/quit game"
@onready var back_button := $HowToPlay/back

## Initialize the main menu as true and How To Play section as false when first time running, and initilizaed cursor as false.
func _ready() -> void:
	start_button.grab_focus() # start button takes focus for key navigation as the first

	mainmenu.visible = true
	howtoplay.visible = false
	cursor_start.visible = true
	cursor_htp.visible = false
	cursor_quit.visible = false
	cursor_back.visible = false

## Starts the game when pressed
func _on_start_game_pressed() -> void:
	scene_manager.start_game()

func _on_start_game_focus_exited() -> void:
	cursor_start.visible = false

func _on_start_game_focus_entered() -> void:
	cursor_start.visible = true
	

## Goes to the How to play section inside of main menu scene through turn on and off nodes.
func _on_howtoplay_game_pressed() -> void:
	mainmenu.visible = false
	howtoplay.visible = true
	back_button.grab_focus() # Sets cursor to back button

func _on_howtoplay_game_focus_exited() -> void:
	cursor_htp.visible = false

func _on_howtoplay_game_focus_entered() -> void:
	cursor_htp.visible = true
	

## Stops the game when pressed
func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_quit_game_focus_entered() -> void:
	cursor_quit.visible = true

func _on_quit_game_focus_exited() -> void:
	cursor_quit.visible = false


## Go back to main menu
func _on_back_pressed() -> void:
	mainmenu.visible = true
	howtoplay.visible = false

func _on_back_focus_entered() -> void:
	cursor_back.visible = true

func _on_back_focus_exited() -> void:
	cursor_back.visible = false
	start_button.grab_focus() # Sets cursor to start button
