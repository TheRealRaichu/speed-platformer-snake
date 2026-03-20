extends Control
var scene_manager
var player

## PAUSE MENU
# child reference
@onready var continue_button := $PanelContainer/VBoxContainer/Continue
@onready var restart_button := $PanelContainer/VBoxContainer/Restart
@onready var quit_button := $PanelContainer/VBoxContainer/Quit

func _ready() -> void:
	continue_button.grab_focus() # continue button takes focus for key navigation
	pause() # pause game

func resume():
	MusicManager.set_paused(false) # tell music manager game is resumed
	scene_manager.is_paused = false # tell scene manager game is resumed
	get_tree().paused = false # unpause game

# Get Reference to scarf and pause the scarg movement temporarily
func pause():
	MusicManager.set_paused(true) # tell music manager game is paused
	scene_manager.is_paused = true # tell scene manager game is paused
	get_tree().paused = true # pause the tree

## Continue the game
func _on_continue_pressed() -> void:
	resume() # resume actions
	get_tree().paused = false # unpause
	queue_free() # die

## Restart game
func _on_restart_pressed() -> void:
	resume()
	scene_manager.start_game()

## Quits to menu
func _on_quit_pressed() -> void: 
	resume()
	scene_manager.main_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_continue_pressed()
