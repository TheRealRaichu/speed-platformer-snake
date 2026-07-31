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

# pause menu
var PAUSE_MENU = preload("res://scenes/pausemenu.tscn")
var current_pause_menu
# GAME DATA

func _ready() -> void:
	# connect signals
	level.base_received_fuel.connect(base_received_fuel)
	level.base_died_out.connect(game_over)
	player.blinked.connect(level.base.player_blinked) # connect player blink signal to player blink
	# set player reference
	UI.player = player
	UI.base = level.base
	if scene_manager.next_gameplay_variant == "practice":
		var life_timer: Timer = level.base.get_node("life timer")
		if life_timer:
			life_timer.stop()
			life_timer.paused = true
		UI.set_life_bar_visible(false)
	else:
		UI.set_life_bar_visible(true)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and not scene_manager.is_paused: # esc pressed
			var current_pause_menu = PAUSE_MENU.instantiate()
			current_pause_menu.scene_manager = scene_manager
			current_pause_menu.player = player
			add_child(current_pause_menu)



# have option to restart the game
func game_over(): # called when campfire dies and by signal
	player.die() # tell player to do death animation
	await get_tree().create_timer(2).timeout # give time for player freeze animation and campfire smoke
	scene_manager.game_over()

func base_received_fuel():
	background.transition() # tell background to do transition
	increment_day_counter() # inc day counter after signal

func increment_day_counter():
	UI.update_day_count() # relay to UI
