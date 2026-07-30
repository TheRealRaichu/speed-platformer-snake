extends Node2D

## TUTORIAL
## Holds all scenes for tutorial.

# reference to scenemanger, set when initialized
var scene_manager

# references to children
@onready var level = $level
@onready var player = $player
@onready var UI = $"Game UI"
@onready var background = $background

# pause menu
var PAUSE_MENU = preload("res://scenes/pausemenu.tscn")
var current_pause_menu

func _ready() -> void:
	# reset score/day for a clean tutorial run
	Globals.day_count = 1
	Globals.score = 1

	# connect signals
	level.base_received_fuel.connect(base_received_fuel)
	level.base_died_out.connect(game_over)

	# set references for UI
	UI.player = player
	UI.base = level.base
	level.tutorial_room_changed.connect(apply_tutorial_room_rules)
	apply_tutorial_room_rules(level.current_tutorial_room_path)

	# stop timer
	var life_timer: Timer = level.base.get_node("life timer")
	if life_timer:
		life_timer.stop()
		life_timer.paused = true

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and not scene_manager.is_paused: # esc pressed
		current_pause_menu = PAUSE_MENU.instantiate()
		current_pause_menu.scene_manager = scene_manager
		current_pause_menu.player = player
		add_child(current_pause_menu)

func game_over():
	player.die()
	await get_tree().create_timer(2).timeout
	scene_manager.game_over()

func base_received_fuel():
	background.transition()
	increment_day_counter()

func increment_day_counter():
	UI.update_day_count()

func apply_tutorial_room_rules(room_path: String) -> void:
	if room_path.is_empty():
		return

	var room_name := room_path.get_file().get_basename()
	var blue_fire_enabled := room_name == "tutorial_8"
	var scarf_enabled := room_name == "tutorial_5" or room_name == "tutorial_11"
	var blink_recharge_enabled := room_name != "tutorial_6" and room_name != "tutorial_9"

	level.base.set_fixed_blue_fire(blue_fire_enabled)
	player.set_scarf_enabled(scarf_enabled)
	player.set_blink_recharge_enabled(blink_recharge_enabled)
