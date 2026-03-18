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

# GAME DATA


func _ready() -> void:
	# connect signals
	level.base_received_fuel.connect(base_received_fuel)
	level.base_died_out.connect(game_over)
	# set player reference
	UI.player_ref = player

func game_over(): # called when campfire dies and by signal
	#await get_tree().create_timer(2) # give time for player freeze animation and campfire smoke
	scene_manager.game_over()

func base_received_fuel():
	increment_day_counter()

func increment_day_counter():
	UI.update_day_count() # relay to UI
