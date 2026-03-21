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

# refernces to the buttons
@onready var start_button := $"MainMenuTitle/start game"
@onready var howtoplay_button := $"MainMenuTitle/howtoplay game"
@onready var quit_button := $"MainMenuTitle/quit game"
@onready var back_button := $HowToPlay/back

@onready var start_text := $"MainMenuTitle/VBoxContainer/StartText"
@onready var htp_text := $"MainMenuTitle/VBoxContainer/HowToPlayText"
@onready var quit_text := $"MainMenuTitle/VBoxContainer/QuitText"

## Initialize the main menu as true and How To Play section as false when first time running, and initilizaed cursor as false.
func _ready() -> void:
	start_button.grab_focus() # start button takes focus for key navigation as the first

	mainmenu.visible = true
	howtoplay.visible = false
	cursor_start.visible = true
	cursor_htp.visible = false
	cursor_quit.visible = false

## Starts the game when pressed
func _on_start_game_pressed() -> void:
	scene_manager.start_game()

func _on_start_game_focus_entered() -> void:
	cursor_start.visible = true
	start_text.focused()

func _on_start_game_focus_exited() -> void:
	cursor_start.visible = false
	start_text.unfocused()

	

## Goes to the How to play section inside of main menu scene through turn on and off nodes.
func _on_howtoplay_game_pressed() -> void:
	mainmenu.visible = false
	howtoplay.visible = true
	back_button.grab_focus() # Sets cursor to back button

func _on_howtoplay_game_focus_exited() -> void:
	cursor_htp.visible = false
	htp_text.unfocused()

func _on_howtoplay_game_focus_entered() -> void:
	cursor_htp.visible = true
	htp_text.focused()
	
	

## Stops the game when pressed
func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_quit_game_focus_entered() -> void:
	cursor_quit.visible = true
	quit_text.focused()

func _on_quit_game_focus_exited() -> void:
	cursor_quit.visible = false
	quit_text.unfocused()


## Go back to main menu
func _on_back_pressed() -> void:
	howtoplay_button.grab_focus()
	mainmenu.visible = true
	howtoplay.visible = false
