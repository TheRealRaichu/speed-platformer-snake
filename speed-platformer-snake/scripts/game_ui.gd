extends Control

## GAME UI
# coupled with Game
# references to children
@onready var day_counter := $"day counter"
@onready var pickup_indicator := $"pickup indicator"
@onready var charge_indicator := $"charge indicator"

var player_ref : Player # set from Game

# day count relay from game to day counter
func update_day_count():
	day_counter.set_day_count(Globals.day_count)

# show pickup relay from game to pickup indicator
func show_pickup(type : Globals.PICKUP_TYPES):
	pickup_indicator.show_pickup(type) 

func _process(delta: float) -> void:
	show_pickup(player_ref.pickup_type) # keep pickup counter updated
	
	# charges
	charge_indicator.allign_charges(player_ref.current_blink_count)
