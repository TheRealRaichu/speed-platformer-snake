extends Control
var scene_manager

## PAUSE MENU
# child reference
@onready var continue_button := $PanelContainer/VBoxContainer/Continue
@onready var restart_button := $PanelContainer/VBoxContainer/Restart
@onready var quit_button := $PanelContainer/VBoxContainer/Quit

func _ready() -> void:
	continue_button.grab_focus() # continue button takes focus for key navigation
	pause() # pause game

func resume():
	scene_manager.is_paused = false
	get_tree().paused = false

func pause():
	scene_manager.is_paused = true
	get_tree().paused = true

## Continue the game
func _on_continue_pressed() -> void:
	resume()
	queue_free()

## Restart game
func _on_restart_pressed() -> void:
	resume()
	scene_manager.switch_scene(scene_manager.SCENES.get("game"))

## Quits to menu
func _on_quit_pressed() -> void: 
	resume()
	scene_manager.switch_scene(scene_manager.SCENES.get("game"))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_continue_pressed()
