extends Node2D

## BASE
# child references
@onready var area := $Area2D # reference to area2D for collisions
@onready var life_timer := $"life timer" # reference to Timer to count life through round
@onready var anim_sprite := $AnimatedSprite2D

# lifespans
const WEAKNESS_THRESHOLD := 0.5 # when to start playing weak animation
const REG_LIFESPAN := 10 # time in seconds per level
const BOSS_LIFESPAN := 19 # time in seconds per boss level
const EARLY_LEVEL_LIFESPAN_BONUS := 10 # extra seconds on the timer for early levels
const EARLY_LEVEL_COUNT := 10 # how many levels count as "early"
const QUICKNESS_MARGIN := 4 # is quick margin, in seconds
# score
const REG_SCORE := 1 # normal clear score
const QUICK_SCORE := 1 # quickness extra points
const BLINKLESS_SCORE := 1 # blinkless extra points
# fuel req
const REG_FUEL_REQ := 1
const BOSS_FUEL_REQ := 2
# success checks
var is_dead := false # is the campfire dead?
var is_blue_fire := false # flag for blue fire level
var current_fuel_count := 0 # fuel in fire currently
var is_quick_success := false # last level was quick? for UI
var player_blinked_this_room := false # player blinked in the current room
var is_blinkless_success := false # last level was blinkless? for UI

# signals
signal fuel_received
signal died_out

func _ready() -> void:
	life_timer.start(get_lifespan()) # begin life timer

# called from process, when player is in range and has fuel
func recieve_fuel():
	AudioManager.play("campfire", 3)
	current_fuel_count += 1
	check_success()

# check if stage is done each time fuel received
func check_success():
	# if 1 fuel in not blue fire or 2 fuel in blue fire
	if (not is_blue_fire and current_fuel_count == REG_FUEL_REQ) or (is_blue_fire and current_fuel_count == BOSS_FUEL_REQ):
		# check if success was quick
		is_quick_success = life_timer.time_left > life_timer.wait_time - QUICKNESS_MARGIN # if stage was completed in less that 5 seconds
		is_blinkless_success = not player_blinked_this_room # set blinkless success flag
		Globals.day_count += 1 # inc day count by 1
		Globals.score += REG_SCORE # score for clear
		Globals.score += QUICK_SCORE if is_quick_success else 0 # score for quick
		Globals.score += BLINKLESS_SCORE if not player_blinked_this_room else 0  # score for blinkless
		
		fuel_received.emit() # exclaim fuel collection
		
		blue_fire_check() # check if this stage is a blue fire stage
		
		# sucess! reset flags
		current_fuel_count = 0
		player_blinked_this_room = false
		life_timer.start(get_lifespan()) # reset life timer and set time accordingly

func get_lifespan() -> int:
	var lifespan := REG_LIFESPAN if not is_blue_fire else BOSS_LIFESPAN # init lifespan
	lifespan += EARLY_LEVEL_LIFESPAN_BONUS if Globals.day_count <= EARLY_LEVEL_COUNT else 0 # add early level bonus
	return lifespan

# becoming blue fire?
func blue_fire_check():
	if Globals.day_count % 10 == 0: # if on tenth day of cycle
		become_blue_fire()
	else:
		become_reg_fire()

func become_blue_fire():
	is_blue_fire = true # set flag
	MusicManager.set_state(MusicManager.STATE.GAMEPLAY_BLUE_FIRE)

func become_reg_fire():
	is_blue_fire = false # set flag
	MusicManager.set_state(MusicManager.STATE.GAMEPLAY)

func player_blinked(): # connected to player blink signal from game.gd
	player_blinked_this_room = true

# returns value between 1.0 and 0.0
func life_timer_remaining_ratio() -> float:
	return life_timer.time_left/life_timer.wait_time 

func _on_life_timer_timeout() -> void: # GAME OVER
	is_dead = true
	anim_sprite.play("dead")
	died_out.emit() # tell everyone campfire died

# play strong animation by color
func strong_animation():
	if not is_blue_fire: anim_sprite.play("full")
	else: anim_sprite.play("blue_full")

func weak_animation():
	if not is_blue_fire: anim_sprite.play("weak")
	else: anim_sprite.play("blue_weak")

func _process(_delta: float) -> void:
	if is_dead: # skip anim tweaks if dead
		return
	if life_timer_remaining_ratio() > WEAKNESS_THRESHOLD and not is_dead: # if not dead and strong
		strong_animation() # play strong
	else: weak_animation() # play weak
	
	
	# check if player is in area
	for body in area.get_overlapping_bodies(): # check all overlapping bodies
		if not body.is_in_group("player"): # if object is not player
			continue # skip to next iteration
		if body.attempt_give_fuel(): # returns true if player has fuel
			recieve_fuel() # continue in function
		break # there will only be one player, so quit looking
	
	## DEBUG MODE !!!
	if not Globals.debug_mode:
		return
	if Input.is_action_just_pressed("debug_die"):
		died_out.emit()
