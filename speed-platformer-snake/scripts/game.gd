extends Node2D

## GAME
## Holds all scenes for gameplay

# REFERENCES
# reference to scenemanger, set when initialized
var scene_manager
# references to children
@onready var level = $level
@onready var player = $player
@onready var UI = $"Game UI"
@onready var background = $background

# references to scenes
const PAUSE_MENU = preload("res://scenes/pausemenu.tscn")

# GAME DATA

func _ready() -> void:
	# connect signals
	level.base_received_fuel.connect(base_received_fuel)
	level.base_died_out.connect(game_over)
	# set player reference
	UI.player = player
	UI.base = level.base

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): # esc pressed
		var pause_inst = PAUSE_MENU.instantiate()
		pause_inst.scene_manager = scene_manager
		add_child(pause_inst)
		get_tree().paused = true

# Have Option to restart the game
func game_over(): # called when campfire dies and by signal
	player.die() # tell player to do death animation
	await get_tree().create_timer(2).timeout # give time for player freeze animation and campfire smoke
	scene_manager.game_over()

func base_received_fuel():
	increment_day_counter()

func increment_day_counter():
	UI.update_day_count() # relay to UI
