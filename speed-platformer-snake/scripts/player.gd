class_name Player
extends CharacterBody2D

## PLAYER
# child references
@onready var scarf := $Scarf
@onready var scarf_box := $"scarf detector"
@onready var anim_sprite := $AnimatedSprite2D
@onready var wall_detector := $"wall detector"
@onready var blink_refresh_timer := $"blink refresh timer"


# ready
func _ready() -> void:
	blink_refresh_timer.wait_time = BLINK_REFRESH_DURATION # set blink timer duration

# ANIMATION HANDLER ======

var no_interrupt := false

func play_anim(animation_name : String): # get animation from process
	# suffix fuel status for player
	if has_fuel(): animation_name += "_has_fuel"
	else: animation_name += "_no_fuel"
	anim_sprite.play(animation_name)

# GAME OVER ===========

var dying := false # is currently in dying animation, diables physics

func die():
	dying = true # set flag
	# play appropriate freeze animation
	if is_on_floor(): play_anim("freeze_ground")
	else: play_anim("freeze_fall")
	AudioManager.play("deathfreeze") # play death sound

# SOUND ===============

const BASE_STEP_INTERVAL := .3 # time interval between step sounds
var current_step_interval := BASE_STEP_INTERVAL
var step_sound_on_cooldown := false # is the step noise on cooldown?

func attempt_play_step_sound():
	AudioManager.play("step") # play step
	step_sound_on_cooldown = true # set cooldown flag
	get_tree().create_timer(current_step_interval).timeout.connect(func(): step_sound_on_cooldown = false) # reset cooldown after timer

# SCARF ================

const TARGET_SCARF_SPEED := 20 # top speed while moving in scarf
const SCARF_DECELERATION := 70 # rate at which you match that scarf speed\
var scarf_invincible := false # is invincible to scarf?
var is_in_scarf := false # is currently in scarf?

func check_in_scarf() -> bool: # check if overlapping with scarf via scarf box
	for area in scarf_box.get_overlapping_areas(): # check each body
		if area.get_parent().is_active: # only if that scarf is active
			is_in_scarf = true
			return is_in_scarf
	is_in_scarf = false
	return is_in_scarf

func scarf_slowdown(): # apply slowdown pentaly to player when overlapping
	if is_blinking or scarf_invincible: # dont apply during blink or invinciblity
		return
	# if moving faster than max scarf speed, slowdown to scarf speed
	if velocity.y > TARGET_SCARF_SPEED: velocity.y = move_toward(velocity.y, TARGET_SCARF_SPEED, SCARF_DECELERATION)
	if velocity.y < -TARGET_SCARF_SPEED: velocity.y = move_toward(velocity.y, -TARGET_SCARF_SPEED, SCARF_DECELERATION)
	if velocity.x > TARGET_SCARF_SPEED: velocity.x = move_toward(velocity.x, TARGET_SCARF_SPEED, SCARF_DECELERATION)
	if velocity.x < -TARGET_SCARF_SPEED: velocity.x = move_toward(velocity.y, -TARGET_SCARF_SPEED, SCARF_DECELERATION)

func scarf_increment(): # call scarf to increment lifespan
	scarf.increment_node_lifespan()

func scarf_pause(paused: bool) -> void:
	# pause player movement and inputs
	set_physics_process(not paused)
	set_process(not paused)
	
	# pause scarf
	scarf.set_physics_process(not paused)
	scarf.set_process(not paused)

const MAX_BLINK := 3 # max amount of blink charges that can be held
const BLINK_REFRESH_DURATION := 3 # time it takes to charge another blink
var current_blink_count := MAX_BLINK # current number of blinks on hand
signal blink_over # signal for when blink finishes, used for animations, called from process

func _on_blink_refresh_timer_timeout() -> void:
	if current_blink_count < MAX_BLINK: # if blinks are not full
		current_blink_count += 1 # add blink charge
	if current_blink_count < MAX_BLINK: # if still not full
		blink_refresh_timer.start() # start timer

func blinked_charge_update(): 
	current_blink_count -= 1 # remove blink charge
	if blink_refresh_timer.is_stopped(): # if refresh timer not going
		blink_refresh_timer.start() # start timer

# PICKUPS ===============

# holding variables
var pickup_on_hand := false # player is carrying fuel?
var pickup_type : Globals.PICKUP_TYPES # taken from pickup

# sugar --
const SUGAR_DURATION := 8 # duration of sugar effect
const SUGAR_SPEED := 500.0 # speed during sugar effect
const SUGAR_JUMP := -500.0 # jump velocity during sugar effect
const SUGAR_WALL_JUMP := -520 # wall jump velocity during sugar effect
const SUGAR_STEP_INTERVAL := .15
var sugar_active := false # sugar active flag
var current_sugar_timer # reference to current sugar timer for refreshes
# reset sugar flags
var sugar_timeout := func(): 
	sugar_active = false
	current_sugar_timer = null
	current_speed = BASE_SPEED
	current_jump_velocity = BASE_JUMP_VELOCITY
	current_wall_jump_velocity = BASE_WALLJUMP_VELOCITY
	current_step_interval = BASE_STEP_INTERVAL
	
# ... --

# getter for pickup on hand
func has_pickup():
	return pickup_on_hand

# called from pickup
func attempt_recieve_pickup(type) -> bool:
	if pickup_on_hand: # if already has pickup
		return false # don't accept it
	
	pickup_on_hand = true # otherwise accept pickup
	pickup_type = type # record type
	return true # and return true

# called from process on input
func attempt_use_pickup():
	if not pickup_on_hand: # if no pickup skip
		return
	
	match pickup_type: # do effect based on held pickup
		Globals.PICKUP_TYPES.NULL:
			pass
		Globals.PICKUP_TYPES.SUGAR:
			use_sugar()
		Globals.PICKUP_TYPES.SCARF_REELER:
			use_reeler()
		Globals.PICKUP_TYPES.PACKAGED_FUEL:
			if not fuel_on_hand: # only if fuel not already on hand
				use_packed_fuel()
		Globals.PICKUP_TYPES.BLINK_RESTORE:
			if current_blink_count < MAX_BLINK: # only if blinks are less than max
				use_blink_restore()
	
	# reset pickup held flags
	pickup_on_hand = false 
	pickup_type = Globals.PICKUP_TYPES.NULL

func use_sugar():
	AudioManager.play("usesugar", -5) # play sugar use noise
	# sugar refresh case
	if sugar_active: # if sugar already active
		current_sugar_timer.timeout.disconnect(sugar_timeout) # disconnect old timer
	# base case
	sugar_active = true # set sugar flag
	current_speed = SUGAR_SPEED # set sugar speed
	current_jump_velocity = SUGAR_JUMP # set sugar jump
	current_wall_jump_velocity = SUGAR_WALL_JUMP # set sugar wall jump
	current_step_interval = SUGAR_STEP_INTERVAL
	# reset timer
	current_sugar_timer = get_tree().create_timer(SUGAR_DURATION) # create and store timer
	current_sugar_timer.timeout.connect(sugar_timeout) # after duration, disable sugar effects

func use_reeler():
	AudioManager.play("usescarfreeler", 3) # play blink restore use noise
	scarf.reel() # tell scarf to reel back

func use_packed_fuel():
	recieve_fuel()

func use_blink_restore():
	AudioManager.play("useblinkrestore") # play blink restore use noise
	current_blink_count = MAX_BLINK # reset blinks

# FUEL ==================

var fuel_on_hand := false # player is carrying fuel?

# getter for fuel on hand
func has_fuel():
	return fuel_on_hand

# called from pickup
func attempt_recieve_fuel() -> bool:
	if fuel_on_hand: # if already has fuel
		return false # don't accept it
	recieve_fuel() # otherwise accept fuel
	return true # and return true

func recieve_fuel():
	AudioManager.play("fuelpickup") # play fuel pickup noise
	fuel_on_hand = true

func give_fuel():
	AudioManager.play("fueldeposit", -2) # play fuel deposit noise
	fuel_on_hand = false # lose fuel
	scarf_increment() # fuel given, increment scarf

# called from base, return true if fuel is had and can be given, false if not
func attempt_give_fuel() -> bool:
	if !fuel_on_hand: # doesn't have fuel?
		return false
	# we have fuel so "give" it to the base
	give_fuel()
	return true # tells base to recieve fuel

# CONTROLLER ==============

# base movement and buffers
const BASE_SPEED := 300.0 # running speed
var current_speed := BASE_SPEED # current speed used in calculations
const GROUND_ACCEL := 100.0 # accleration on ground
const AIR_ACCEL := 60.0 # acceleration in air
const BASE_JUMP_VELOCITY := -350.0 # jump impulse ~ 2.5 blocks
var current_jump_velocity := BASE_JUMP_VELOCITY # current jump velocity for calculations
const BUFFER_DURATION := 0.1 # duration of buffer time 
const COYOTE_DURATION := 0.05 # duration of coyote time 
var jump_buffer := false # is the player's jump currently buffered?
var coyote_buffer := false # is the player's grounded state buffered?
var was_on_floor := false # coyote helper flagd
var right_buffer := false # is the right input currently buffered?
var left_buffer := false # is the left input currently buffered?
var facing_right := false # direction player is facing

# normal jump
const BASE_GRAVITY := 1600 # gravity on inital jump/falling of ledge
const RELEASE_GRAVITY := 3200 # gravity applied after jump key is released, or in fast_fall
const FAST_FALL_GRAVITY := 6400 # gravity applied after jump key is released, or in fast_fall
const HELD_APEX_GRAVITY := 800 # gravity from when approaching jump apex while jump key is held
const PRE_APEX_INTERVAL := .2 # timer before apex gravity is in effect
var is_jump := false # tracks if player is in their own jump or just falling
var jump_released := false # tracks when player releases jump input mid jump
var fast_fall := false # tracks fast fall state
var current_gravity := BASE_GRAVITY # current gravity used in physics_process

# wall jump
const BASE_WALLJUMP_VELOCITY := -400.0 # y velocity after wall jump
var current_wall_jump_velocity := BASE_WALLJUMP_VELOCITY
const WALL_PUSHBACK_VELOCITY := 300 # x velocity after wall jump
const WALLJUMP_IGNORE_DURATION := .15 # duration to ignore x input after wall jump
var walljump_ignore_x := false # should ignore deceleration and run input?
var is_wall_slide := false # is sliding on wall?
const WALL_SLIDE_Y_VELOCITY := 100 # target velocity when sliding down a wall

# blink
const BLINKING_VELOCITY := 500 # velocity while player is travelling in blink, affects blink distance
const BLINK_OUT_VELOCITY := 400 # amount of velocity set in blink direction after charge blink
const BLINK_DURATION := .15 # how long blink takes from start to finish
const BLINK_COOLDOWN := .5 # blink cooldown duration
const BLINK_SCARF_I_DURATION := .25 # duration of being invincible to scarf after blink
var is_blinking := false # ignore all other physics while true
var blink_on_cooldown := false # is blink on cooldown?

# HELPERS FOR CHARACTER CONTROLLER
# called from physics process

func reset_jump_attributes():
	is_jump = false # not currently jumping
	jump_released = false # not jumping so reset
	fast_fall = false # not fast falling
	current_gravity = BASE_GRAVITY # reset gravity

func _physics_process(delta: float) -> void:
	if dying: # if flag
		# gravity and decelerate
		velocity.y += current_gravity * delta # apply gravity to y velocity
		velocity.x = move_toward(velocity.x, 0, GROUND_ACCEL if is_on_floor() else AIR_ACCEL) # decelerate to 0, taken from part below
		if is_on_floor() and (not anim_sprite.is_playing() or anim_sprite.animation == "freeze_fall"): # be grounded and await death animation finish
			play_anim("fainted") # ends both air and ground fainting animations
		move_and_slide() # duh
		return # dont do anything else
	if is_blinking: # if currently in blink
		move_and_slide()
		return
	
	# MOVEMENT
	# TAKE INPUT DIRECTIONS
	var horizontal_direction := Input.get_axis("move_left", "move_right") # get horizontal axis input
	var vertical_direction := Input.get_axis("move_up", "move_down") # get vertical axis input
	
	# BUFFERING
	# rightward
	if (Input.is_action_just_released("move_right") or Input.is_action_just_pressed("move_right")) and not right_buffer: # if right just released and buffer not already active
		right_buffer = true # set right buffer flag to true
		get_tree().create_timer(BUFFER_DURATION).timeout.connect(func(): right_buffer = false) # set buffer flag to false after buffer duration
	# leftward
	if (Input.is_action_just_released("move_left") or Input.is_action_just_pressed("move_left")) and not left_buffer: # if left just released and buffer not already active
		left_buffer = true # set left buffer flag to true
		get_tree().create_timer(BUFFER_DURATION).timeout.connect(func(): left_buffer = false) # set buffer flag to false after buffer duration
	# jump
	if Input.is_action_just_pressed("jump") and not jump_buffer: # if left just released and buffer not already active
		jump_buffer = true # set jump buffer flag to true
		get_tree().create_timer(BUFFER_DURATION).timeout.connect(func(): jump_buffer = false) # set buffer flag to false after buffer duration
	# coyote
	if is_on_floor(): # check grounded status
		was_on_floor = true # prepare was grounded flag 
	if was_on_floor and not is_on_floor() and not is_jump: # if was grounded and now not, and not because of jump
		was_on_floor = false # reset grounded tag
		coyote_buffer = true # set flag to true
		get_tree().create_timer(COYOTE_DURATION).timeout.connect(func(): coyote_buffer = false) # set buffer flag to false after buffer duration
	
	# RUNNING
	if not walljump_ignore_x: # if x velocity change is being accepted
		# get acceleration based on grounded status
		var horizontal_acceleration = GROUND_ACCEL if is_on_floor() else AIR_ACCEL # 100 on ground, 60 in air
		# move in direction of acceleration or decelerate
		if horizontal_direction:
			velocity.x = move_toward(velocity.x, horizontal_direction * current_speed, horizontal_acceleration) # accelerate toward top speed
		else: # no dir held
			velocity.x = move_toward(velocity.x, 0, horizontal_acceleration) # decelerate to 0
	
	# JUMPING
	# reset all jump status if on the floor
	if is_on_floor() or is_on_wall():
		reset_jump_attributes()
	
	# base jump if on floor
	if (is_on_floor() or coyote_buffer) and (Input.is_action_just_pressed("jump") or jump_buffer):
		AudioManager.play("jump", -7) # play jump noise
		jump_buffer = false # reset jump buffer
		velocity.y = current_jump_velocity # apply jump velocity
		is_jump = true # currently jumping
		# create apex grav timer
		get_tree().create_timer(PRE_APEX_INTERVAL).timeout.connect(func(): # after a timer with apex interval duration
			if Input.is_action_pressed("jump") and is_jump and not jump_released and not fast_fall: # only if jump is still held and was never released and not in fast fall during jump
				current_gravity = HELD_APEX_GRAVITY) # set gravity to apex gravity
	
	# WALL JUMPING
	# put on elif to avoid duplicate jumps
	elif is_on_wall_only() and (Input.is_action_just_pressed("jump") or jump_buffer): # on wall only and jumped (or jump buffered)
		AudioManager.play("walljump", 2) # play jump noise
		jump_buffer = false # reset jump buffer
		velocity.y = current_wall_jump_velocity # set y velocity accordingly
		# set flags for wall jump
		walljump_ignore_x = true 
		is_jump = true
		# check what side wall is on
		if get_wall_normal().x > 0: # wall on left
			velocity.x = WALL_PUSHBACK_VELOCITY # push to the right
		else: # wall on right
			velocity.x = -WALL_PUSHBACK_VELOCITY # push to the left
		# create timer to reset ignore flag after ignore duration
		get_tree().create_timer(WALLJUMP_IGNORE_DURATION).timeout.connect(func(): walljump_ignore_x = false)
	
	# JUMP RELEASE
	if Input.is_action_just_released("jump") and is_jump: # if are jumping and jump was released
		jump_released = true # flag for jump key has been released
		current_gravity = RELEASE_GRAVITY # adjust gravity accordingly
	
	# FAST FALL
	if not is_on_floor() and Input.is_action_pressed("ui_down"):
		fast_fall = true
		current_gravity = FAST_FALL_GRAVITY
	
	# GRAVITY
	if not is_on_floor():
		velocity.y += current_gravity * delta # apply gravity to y velocity
	
	# WALL SLIDING
	if is_on_wall_only() and (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
		is_wall_slide = true # set flag
	else:
		is_wall_slide = false # set flag
	AudioManager.play_wall_slide(is_wall_slide) # play audio accodingly
	
	 
	if is_wall_slide and velocity.y > 0: # if wall sliding downward 
		velocity.y = move_toward(velocity.y, WALL_SLIDE_Y_VELOCITY, 50)  # move toward wall sliding speed 
	

	# BLINKING
	if Input.is_action_just_pressed("ability") and not blink_on_cooldown and current_blink_count > 0: # when blink input pressed and cooldown not active and atleast one blink charge
		AudioManager.play("blink") # play audio
		# cooldown
		blinked_charge_update() # tell blink management system that blink was used
		blink_on_cooldown = true # start cooldown
		get_tree().create_timer(BLINK_COOLDOWN).timeout.connect(func(): blink_on_cooldown = false) # start timer to end cooldown
		# check direction
		var blink_vector := Vector2(horizontal_direction, vertical_direction) # take direction of blink
		blink_vector = blink_vector.normalized() # normalize
		
		# fix jump flags
		reset_jump_attributes()
		
		velocity = blink_vector*BLINKING_VELOCITY # set velocity during blink
		is_blinking = true # mark player as blinking
		
		no_interrupt = true # mark as unanimatable
		play_anim("blink_in") # play in animation
		
		await get_tree().create_timer(BLINK_DURATION).timeout
		
		play_anim("blink_out") # play out animation
		
		# flag update
		is_blinking = false # no longer blinking
		scarf_invincible = true # post blink invincibility
		# set timer to remove invincibility
		get_tree().create_timer(BLINK_SCARF_I_DURATION).timeout.connect(func(): scarf_invincible = false) # start timer to end cooldown
		
		# set velocity
		velocity = Vector2(
			BLINK_OUT_VELOCITY * blink_vector.x,
			BLINK_OUT_VELOCITY * blink_vector.y)
		
		# finish blink out animation and mark as animatable
		await anim_sprite.animation_finished
		no_interrupt = false
	
	# scarf penalty
	if check_in_scarf():
		scarf_slowdown() # enact scarf penalty
	AudioManager.scarf_collision_playing = true if is_in_scarf else false # set scarf collision noise depending on if in scarf
	
	
	move_and_slide() # duh
	
	# SOUND
	# stepping
	if is_on_floor() and velocity.x and not step_sound_on_cooldown: # if moving on ground and step sound off cooldown
		attempt_play_step_sound()
	
	# ANIMATION PROCESS
	# ordered by precedence (e.g. check tangle after run)
	var was_blinking := false
	# facing
	if horizontal_direction:
		anim_sprite.flip_h = false if horizontal_direction < 0 else true
	# don't interrupt
	if not no_interrupt:
		# blink in
		if is_blinking:
			pass # handled in blink controller
		# death pass
		elif dying:
			pass
		# tangled in scarf
		elif is_in_scarf:
			play_anim("tangled")
		# wall slide
		elif is_wall_slide:
			play_anim("wall_slide")
		# jump rise
		elif velocity.y < 0 and not is_on_floor():
			play_anim("jump_rise")
		# jump fall
		elif velocity.y > 0 and not is_on_floor():
			play_anim("jump_fall")
		# run
		elif horizontal_direction:
			play_anim("run")
		# idle
		elif not velocity.x and is_on_floor(): # if "idle"
			play_anim("idle")
		# DEATH IS HANDLED IN THE die() FUNCTION AND AT THE TOP OF PHYSICS PROCESS


# PROCESS ====== (general use, call back up)

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("use_item"): # when item button is pressed
		attempt_use_pickup() # try to use item
