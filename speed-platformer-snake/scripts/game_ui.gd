extends Control

## GAME UI
# references to children
@onready var day_counter := $"day counter"
@onready var pickup_indicator := $"pickup indicator"

# day count relay from game to day counter
func update_day_count(day_count):
	day_counter.set_day_count(day_count)

# show pickup relay from game to pickup indicator
func show_pickup(type : Globals.PICKUP_TYPES):
	pickup_indicator.show_pickup(type) 
