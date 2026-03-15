extends Control

## GAME UI
# references to children
@onready var day_counter = $"day counter"

func update_day_count(day_count):
	day_counter.set_day_count(day_count)
