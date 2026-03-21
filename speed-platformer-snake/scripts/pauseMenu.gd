extends Control
var scene_manager
var player

## PAUSE MENU
# child reference
@onready var continue_button := $PanelContainer/VBoxContainer/Continue
@onready var restart_button := $PanelContainer/VBoxContainer/Restart
@onready var quit_button := $PanelContainer/VBoxContainer/Quit

# child references to the cursor sprites
@onready var cursor_continue := $Cursor_1
@onready var cursor_restart := $Cursor_2
@onready var cursor_quit := $Cursor_3

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

# Get Reference to scarf and pause the scarg movement temporarily
func pause():
	MusicManager.set_paused(true) # keep music playing normally while paused
	scene_manager.is_paused = true # tell scene manager game is paused
	get_tree().paused = true # pause the tree

## Placed each cursor next to the buttons and turn them on when focused

## CONTINUE
func _on_continue_pressed() -> void:
	resume() # resume actions
	get_tree().paused = false # unpause
	queue_free() # die

func _on_continue_focus_entered() -> void:
	cursor_continue.visible = true

func _on_continue_focus_exited() -> void:
	cursor_continue.visible = false

## RESTART
func _on_restart_pressed() -> void:
	resume()
	scene_manager.switch_scene(scene_manager.SCENES.get("game"))

func _on_restart_focus_entered() -> void:
	cursor_restart.visible = true

func _on_restart_focus_exited() -> void:
	cursor_restart.visible = false


## QUITS
func _on_quit_pressed() -> void: 
	resume()
	scene_manager.switch_scene(scene_manager.SCENES.get("main_menu"))

func _on_quit_focus_entered() -> void:
	cursor_quit.visible = true

func _on_quit_focus_exited() -> void:
	cursor_quit.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_continue_pressed()