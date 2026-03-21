extends Control

## GAME UI
# coupled with Game
# references to children
@onready var day_counter := $"day counter"
@onready var pickup_indicator := $"pickup indicator"
@onready var charge_indicator := $"charge indicator" 
@onready var life_bar := $"life bar"

var player : Player # set from Game
var base # set from Game

# day count relay from game to day counter
func update_day_count():
	day_counter.set_day_count(Globals.score, base.recent_quick_success) # display score and text based on speed

# show pickup relay from game to pickup indicator
func show_pickup(type : Globals.PICKUP_TYPES):
	pickup_indicator.show_pickup(type) 


func _process(_delta: float) -> void:
	
	show_pickup(player.pickup_type) # keep pickup counter updated
	
	# charges
	charge_indicator.allign_charges(player.current_blink_count)
	
	# set life bar percentage
	life_bar.value = base.life_timer_remaining_ratio()
