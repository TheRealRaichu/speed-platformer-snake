extends Control
var scene_manager
var player

## PAUSE MENU
# child reference
@export var continue_button : UIButton
@export var restart_button : UIButton
@export var quit_button : UIButton

func _ready() -> void:
	continue_button.grab_focus() # continue button takes focus for key navigation
	pause() # pause game

func resume():
	MusicManager.set_paused(false) # tell music manager game is resumed
	scene_manager.is_paused = false # tell scene manager game is resumed
	get_tree().paused = false # unpause game
	queue_free() # die

# Get Reference to scarf and pause the scarg movement temporarily
func pause():
	MusicManager.set_paused(true) # tell music manager game is paused
	scene_manager.is_paused = true # tell scene manager game is paused
	get_tree().paused = true # pause the tree

## CONTINUE
func _on_continue_pressed() -> void:
	resume() # resume actions

## RESTART
func _on_restart_pressed() -> void:
	resume()
	scene_manager.start_game()

## QUITS
func _on_quit_pressed() -> void: 
	resume()
	scene_manager.main_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled() # stop input from bubbling up
		_on_continue_pressed()
