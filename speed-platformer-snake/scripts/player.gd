extends CharacterBody2D

## PLAYER

# CONTROLLER ==============

# base movement
const SPEED := 300.0 # running speed
const JUMP_VELOCITY := -500.0 # jump impulse

# normal jump
const BASE_GRAVITY := 1600 # gravity on inital jump/falling of ledge
const RELEASE_GRAVITY := 6400 # gravity applied after jump key is released, 
const HELD_APEX_GRAVITY := 800 # gravity from when approaching jump apex while jump key is held
const PRE_APEX_INTERVAL := .2 # timer before apex gravity is in effect
var is_jump := false # tracks if player is in their own jump or just falling
var jump_released := false # tracks when player releases jump input mid jump
var current_gravity := BASE_GRAVITY # current gravity used in physics_process

# wall jump
const WALLJUMP_VELOCITY := -400.0 # y velocity after wall jump
const WALL_PUSHBACK_VELOCITY := 300 # x velocity after wall jump
const WALLJUMP_IGNORE_DURATION := .15 # duration to ignore x input after wall jump
var walljump_ignore_x := false # should ignore deceleration and run input?
var wall_slide := false # is sliding on wall?
const WALL_SLIDE_Y_VELOCITY := 100 # target velocity when sliding down a wall

# blink
const TELEPORTATION_DISTANCE := 100 # distance teleported in pixels
const BLINK_OUT_VELOCITY := 500 # amount of velocity added in blink direction after charge blink
const BLINK_DURATION := .2 # how long blink takes from start to finish
const MAX_BLINK := 3 # max amount of blink charges that can be held
var current_blink : int # current number of blinks on hand

# HELPERS FOR CHARACTER CONTROLLER
# called from physics process
func set_apex_timer():
	var apex_timer = Timer.new() # initialize apex gravity timer and application
	# initialize timer attributes
	apex_timer.one_shot = true
	apex_timer.wait_time = PRE_APEX_INTERVAL
	apex_timer.timeout.connect(func():
		if Input.is_action_pressed("jump") and not jump_released: # only if jump is still held and was never released
			current_gravity = HELD_APEX_GRAVITY)
	add_child(apex_timer) # add child
	apex_timer.start() # begin timer

func set_walljump_ignore_x_timer(): # ensures that x impulse from wall has some impact before player input works against it
	var ignore_timer = Timer.new() # initialize ignore timer
	# initialize timer attributes
	ignore_timer.one_shot = true
	ignore_timer.wait_time = WALLJUMP_IGNORE_DURATION 
	ignore_timer.timeout.connect(func(): walljump_ignore_x = false) # stop ignoring x input
	add_child(ignore_timer) # add child
	ignore_timer.start() # beginm timer

func _physics_process(delta: float) -> void:
	# MOVEMENT
	# TAKE INPUT DIRECTIONS
	var horizontal_direction := Input.get_axis("move_left", "move_right") # get horizontal axis input
	var vertical_direction := Input.get_axis("move_up", "move_down") # get vertical axis input
	
	# RUNNING
	if not walljump_ignore_x: # if x velocity change is being accepted
		# get acceleration based on grounded status
		var horizontal_acceleration = 100 if is_on_floor() else 60 # 100 on ground, 60 in air
		# move in direction of acceleration or decelerate
		if horizontal_direction:
			velocity.x = move_toward(velocity.x, horizontal_direction * SPEED, horizontal_acceleration) # accelerate toward top speed
		else: # no dir held
			velocity.x = move_toward(velocity.x, 0, horizontal_acceleration) # decelerate to 0
	
	# JUMPING
	# reset all jump status if on the floor
	if is_on_floor() or is_on_wall():
		is_jump = false # not currently jumping
		jump_released = false # not jumping so reset
		current_gravity = BASE_GRAVITY # reset gravity
	
	# base jump if on floor
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_VELOCITY # apply jump velocity
		is_jump = true # currently jumping
		set_apex_timer() # initialize timer for apex gravity
	
	# releasing while in jump makes you fall REALLY FAST
	if Input.is_action_just_released("jump") and is_jump: # if are jumping and jump was released
		jump_released = true # flag for jump key has been released
		current_gravity = RELEASE_GRAVITY # adjust gravity accordingly
	
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
		set_walljump_ignore_x_timer() # set timer
	# check if wall sliding
	if is_on_wall_only() and (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
		wall_slide = true
	else:
		wall_slide = false
	
	if wall_slide and velocity.y > 0: # if wall sliding downward 
		velocity.y = move_toward(velocity.y, WALL_SLIDE_Y_VELOCITY, 50)  # move toward wall sliding speed 
	

	# BLINKING
	if Input.is_action_just_pressed("ability"): # when blink input pressed
		var blink_vector := Vector2(horizontal_direction, vertical_direction) # take direction of blink
		blink_vector = blink_vector.normalized() # normalize
		
		# flag as a jump and reset jump release
		is_jump = true
		jump_released = false
		
		var cur_velocity := velocity # record velocity
		var new_pos := Vector2( # compute new position
			self.position.x + TELEPORTATION_DISTANCE * blink_vector.x,
			self.position.y + TELEPORTATION_DISTANCE * blink_vector.y)
		
		self.visible = false # disappear (will be animation later)
		
		await get_tree().create_timer(.2).timeout
		
		self.visible = true # come back
		
		# set new position
		position = new_pos
		if not Input.is_action_pressed("ability"): # if ability is not held
			velocity = cur_velocity # just restore velocity
		else: # ability is held
			velocity = cur_velocity + Vector2( # also add extra velocity
				BLINK_OUT_VELOCITY * blink_vector.x,
				BLINK_OUT_VELOCITY * blink_vector.y)
	
	move_and_slide() # duh

# END OF CONTROLLER ======
