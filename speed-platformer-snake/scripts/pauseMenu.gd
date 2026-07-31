extends Control
var scene_manager
var player

## PAUSE MENU
# child reference
@onready var continue_button := $PanelContainer/VBoxContainer/ContinueNode/Continue
@onready var restart_button := $PanelContainer/VBoxContainer/RestartNode/Restart
@onready var quit_button := $PanelContainer/VBoxContainer/QuitNode/Quit

# child references to the cursor sprites
@onready var cursor_continue := $PanelContainer/VBoxContainer/ContinueNode/ContinueCursor
@onready var cursor_restart := $PanelContainer/VBoxContainer/RestartNode/RestartCursor
@onready var cursor_quit := $PanelContainer/VBoxContainer/QuitNode/QuitCursor
# ui text
@onready var coninue_text := $"PanelContainer/VBoxContainer/ContinueNode/ContinueText"
@onready var restart_text := $"PanelContainer/VBoxContainer/RestartNode/RestartText"
@onready var quit_text := $"PanelContainer/VBoxContainer/QuitNode/QuitText"

func _ready() -> void:
	continue_button.grab_focus() # continue button takes focus for key navigation

	# Sets the cursors to false at the start
	cursor_continue.visible = true
	cursor_restart.visible = false
	cursor_quit.visible = false
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
	

func _on_continue_focus_entered() -> void:
	cursor_continue.visible = true
	coninue_text.focused()

func _on_continue_focus_exited() -> void:
	cursor_continue.visible = false
	coninue_text.unfocused()

## RESTART
func _on_restart_pressed() -> void:
	resume()
	scene_manager.restart_current_mode()

func _on_restart_focus_entered() -> void:
	cursor_restart.visible = true
	restart_text.focused()

func _on_restart_focus_exited() -> void:
	cursor_restart.visible = false
	restart_text.unfocused()


## QUITS
func _on_quit_pressed() -> void: 
	resume()
	scene_manager.main_menu()

func _on_quit_focus_entered() -> void:
	cursor_quit.visible = true
	quit_text.focused()

func _on_quit_focus_exited() -> void:
	cursor_quit.visible = false
	quit_text.unfocused()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled() # stop input from bubbling up
		_on_continue_pressed()