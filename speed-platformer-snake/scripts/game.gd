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
var day_count := 1 # score for how many days survived, start at one for day one

func _ready() -> void:
	# connect signals
	level.base_recieved_fuel.connect(base_recieved_fuel)
	# set player reference
	UI.player_ref = player

func base_recieved_fuel():
	increment_day_counter()

func increment_day_counter():
	day_count += 1 # inc day count
	UI.update_day_count(day_count) # relay to UI
