extends Node2D

## BASE
# child references
@onready var area := $Area2D # reference to area2D for collisions
@onready var life_timer := $"life timer" # reference to Timer to count life through round

signal fuel_recieved

func _ready() -> void:
	life_timer.start() # begin life timer

# called from process, when player is in range and has fuel
func recieve_fuel():
	life_timer.start() # reset life timer
	fuel_recieved.emit() # exclaim fuel collection

# returns value between 1.0 and 0.0
func life_timer_remaining_ratio() -> float:
	return life_timer.time_left/life_timer.wait_time 

func _on_life_timer_timeout() -> void:
	pass # GAME OVER

func _process(delta: float) -> void:
	
	# check if player is in area
	for body in area.get_overlapping_bodies(): # check all overlapping bodies
		if not body.is_in_group("player"): # if object is not player
			continue # skip to next iteration
		if body.attempt_give_fuel(): # returns true if player has fuel
			recieve_fuel() # continue in function
		break # there will only be one player, so quit looking
