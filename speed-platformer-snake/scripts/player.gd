extends CharacterBody2D

## PLAYER

# PICKUPS ===============

var pickup_on_hand := false # player is carrying fuel?
var pickup_type # taken from pickup

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
	pass

# FUEL ==================

var fuel_on_hand := false # player is carrying fuel?

# getter for fuel on hand
func has_fuel():
	return fuel_on_hand

# called from pickup
func attempt_recieve_fuel() -> bool:
	if fuel_on_hand: # if already has fuel
		return false # don't accept it
	print_debug("nabbed")
	fuel_on_hand = true # otherwise accept fuel
	return true # and return true

# called from base, return true if fuel is had and can be given, false if not
func attempt_give_fuel() -> bool:
	if !fuel_on_hand: # doesn't have fuel?
		return false
	print_debug("give")
	# we have fuel so "give" it to the base
	fuel_on_hand = false # lose fuel
	return true # tells base to recieve fuel

# CONTROLLER ==============

# base movement and buffers
const MAX_SPEED := 300.0 # running speed
const GROUND_ACCEL := 100.0 # accleration on ground
const AIR_ACCEL := 60.0 # acceleration in air
const JUMP_VELOCITY := -350.0 # jump impulse ~ 2.5 blocks
const BUFFER_DURATION := .1 # duration of coyote and buffer time 
var jump_buffer := false # is the player's jump currently buffered?
var right_buffer := false # is the right input currently buffered?
var left_buffer := false # is the left input currently buffered?

# normal jump
const BASE_GRAVITY := 1600 # gravity on inital jump/falling of ledge
const HARD_GRAVITY := 6400 # gravity applied after jump key is released, or in fast_fall
const HELD_APEX_GRAVITY := 800 # gravity from when approaching jump apex while jump key is held
const PRE_APEX_INTERVAL := .2 # timer before apex gravity is in effect
var is_jump := false # tracks if player is in their own jump or just falling
var jump_released := false # tracks when player releases jump input mid jump
var fast_fall := false # tracks fast fall state
var current_gravity := BASE_GRAVITY # current gravity used in physics_process

# wall jump
const WALLJUMP_VELOCITY := -400.0 # y velocity after wall jump
const WALL_PUSHBACK_VELOCITY := 300 # x velocity after wall jump
const WALLJUMP_IGNORE_DURATION := .15 # duration to ignore x input after wall jump
var walljump_ignore_x := false # should ignore deceleration and run input?
var wall_slide := false # is sliding on wall?
const WALL_SLIDE_Y_VELOCITY := 100 # target velocity when sliding down a wall

# blink
const BLINKING_VELOCITY := 600 # velocity while player is travelling in blink, affects blink distance
const BLINK_OUT_VELOCITY := 400 # amount of velocity set in blink direction after charge blink
const BLINK_DURATION := .1 # how long blink takes from start to finish
const MAX_BLINK := 3 # max amount of blink charges that can be held
var current_blink : int # current number of blinks on hand
const BLINK_COOLDOWN := .5 # blink cooldown duration
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
	if (Input.is_action_just_released("jump") or Input.is_action_just_pressed("jump")) and not jump_buffer: # if left just released and buffer not already active
		jump_buffer = true # set jump buffer flag to true
		get_tree().create_timer(BUFFER_DURATION).timeout.connect(func(): jump_buffer = false) # set buffer flag to false after buffer duration
	
	# RUNNING
	if not walljump_ignore_x: # if x velocity change is being accepted
		# get acceleration based on grounded status
		var horizontal_acceleration = GROUND_ACCEL if is_on_floor() else AIR_ACCEL # 100 on ground, 60 in air
		# move in direction of acceleration or decelerate
		if horizontal_direction:
			velocity.x = move_toward(velocity.x, horizontal_direction * MAX_SPEED, horizontal_acceleration) # accelerate toward top speed
		else: # no dir held
			velocity.x = move_toward(velocity.x, 0, horizontal_acceleration) # decelerate to 0
	
	# JUMPING
	# reset all jump status if on the floor
	if is_on_floor() or is_on_wall():
		reset_jump_attributes()
	
	# base jump if on floor
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_VELOCITY # apply jump velocity
		is_jump = true # currently jumping
		# create apex grav timer
		get_tree().create_timer(PRE_APEX_INTERVAL).timeout.connect(func(): # after a timer with apex interval duration
			if Input.is_action_pressed("jump") and is_jump and not jump_released and not fast_fall: # only if jump is still held and was never released and not in fast fall during jump
				current_gravity = HELD_APEX_GRAVITY) # set gravity to apex gravity
	
	# releasing while in jump makes you fall REALLY FAST
	if Input.is_action_just_released("jump") and is_jump: # if are jumping and jump was released
		jump_released = true # flag for jump key has been released
		current_gravity = HARD_GRAVITY # adjust gravity accordingly
	
	# FAST FALL
	if not is_on_floor() and Input.is_action_pressed("ui_down"):
		fast_fall = true
		current_gravity = HARD_GRAVITY
	
	# GRAVITY
	if not is_on_floor():
		velocity.y += current_gravity * delta # apply gravity to y velocity
	
	# WALL JUMPING
	if is_on_wall_only() and Input.is_action_just_pressed("jump"): # on wall only and jumped
		velocity.y = WALLJUMP_VELOCITY # set y velocity accordingly
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
	
	# check if wall sliding
	if is_on_wall_only() and (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
		wall_slide = true
	else:
		wall_slide = false
	
	if wall_slide and velocity.y > 0: # if wall sliding downward 
		velocity.y = move_toward(velocity.y, WALL_SLIDE_Y_VELOCITY, 50)  # move toward wall sliding speed 
	

	# BLINKING
	if Input.is_action_just_pressed("ability") and not blink_on_cooldown: # when blink input pressed and cooldown not active
		# cooldown
		blink_on_cooldown = true # start cooldown
		get_tree().create_timer(BLINK_COOLDOWN).timeout.connect(func(): blink_on_cooldown = false) # start timer to end cooldown
		# check direction
		var blink_vector := Vector2(horizontal_direction, vertical_direction) # take direction of blink
		blink_vector = blink_vector.normalized() # normalize
		
		# fix jump flags
		reset_jump_attributes()
		
		velocity = blink_vector*BLINKING_VELOCITY # set velocity during blink
		is_blinking = true # mark player as blinking
		
		# animate
		#self.visible = false # disappear (will be animation later)
		
		await get_tree().create_timer(BLINK_DURATION).timeout
		
		self.visible = true # come back
		
		# flag update
		is_blinking = false # no longer blinking
		
		# set velocity
		velocity = Vector2(
			BLINK_OUT_VELOCITY * blink_vector.x,
			BLINK_OUT_VELOCITY * blink_vector.y)
	
	move_and_slide() # duh

# PROCESS ====== (general use, call back up)

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("use_item"): # when item button is pressed
		attempt_use_pickup() # try to use item
