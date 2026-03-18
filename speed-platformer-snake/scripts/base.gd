extends Node2D

## BASE
# child references
@onready var area := $Area2D # reference to area2D for collisions
@onready var life_timer := $"life timer" # reference to Timer to count life through round
# temp blue indicator
@onready var blue_fire := $ColorRect
@onready var life_bar := $"life bar"

const REG_LIFESPAN := 10 # time in seconds per level
const BOSS_LIFESPAN := 18 # time in seconds per boss level

# success checks
var is_blue_fire := false
var current_fuel_count := 0

signal fuel_received

func _ready() -> void:
	life_timer.start(REG_LIFESPAN) # begin life timer

# called from process, when player is in range and has fuel
func recieve_fuel():
	current_fuel_count += 1
	check_success()

# check if stage is done each time fuel received
func check_success():
	# if 1 fuel in not blue fire or 2 fuel in blue fire
	if (not is_blue_fire and current_fuel_count == 1) or (is_blue_fire and current_fuel_count == 2):
		# sucess! reset flags
		current_fuel_count = 0
		life_timer.start(REG_LIFESPAN if Globals.day_count % 10 != 0 else BOSS_LIFESPAN) # reset life timer and set time accordingly
		Globals.day_count += 1 # inc day count
		fuel_received.emit() # exclaim fuel collection
		blue_fire_check()

# becoming blue fire?
func blue_fire_check():
	if Globals.day_count % 10 == 0: # if on tenth day of cycle
		become_blue_fire()
	else:
		become_reg_fire()

func become_blue_fire():
	is_blue_fire = true # set flag
	blue_fire.visible = true # temp

func become_reg_fire():
	is_blue_fire = false # set flag
	blue_fire.visible = false # temp

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

	
	# set modulate of campfire to timer ratio
	$texture.modulate.a = lerp(0.0, 1.0, life_timer_remaining_ratio())
	
	# set life bar percentage
	life_bar.value = life_timer_remaining_ratio()
