class_name Pickup
extends Node2D

## PICKUP

# child references
@onready var area = $Area2D # reference to area for player detection
@onready var anim_sprite := $AnimatedSprite2D

# it sucks but i gotta have a local one because the export is broken
enum PICKUP_TYPES {
	NULL,
	FUEL,
	SUGAR,
	SCARF_REELER,
	PACKAGED_FUEL,
	BLINK_RESTORE,
	random,
	# etc..
}

@export var type : PICKUP_TYPES # globals contains all pickup types

var player : Player
signal collected # emitted when pickup is collected

func _ready() -> void:
	if type == PICKUP_TYPES.random:
		type = randi_range(PICKUP_TYPES.SUGAR, PICKUP_TYPES.BLINK_RESTORE) # pick a random type
	set_sprite()

func set_sprite():
	anim_sprite.play("fuel")
	match type:
		PICKUP_TYPES.SCARF_REELER:
			anim_sprite.play("reeler")
		PICKUP_TYPES.PACKAGED_FUEL:
			anim_sprite.play("packaged_fuel")
		PICKUP_TYPES.BLINK_RESTORE:
			anim_sprite.play("blink_restore")
		PICKUP_TYPES.SUGAR:
			anim_sprite.play("sugar")

func _process(_delta: float) -> void:
	# check for player in range
	var player_spotted := false # has player been found this frame?
	
	for body in area.get_overlapping_bodies():
		if not body.is_in_group("player"): # if object is not player
			continue # skip to next iteration
		# item swap
		player_spotted = true # mark player as found
		player = body # store player reference
		body.attempt_swap.connect(be_swapped) # connect player attempt swap to swap function
		# item pickup
		var accepeted := false # is accepted by player?
		 # if pickup is fuel
		if type == Globals.PICKUP_TYPES.FUEL:
			accepeted = body.attempt_recieve_fuel() # returns true if player takes fuel
		# is pickup of another type
		else: accepeted = body.attempt_recieve_pickup(type) # returns true if player takes pickup
		if accepeted: be_collected() # self is collected if player has accepted it
	# disconnect signal if player not found
	if not player_spotted and player and player.attempt_swap.is_connected(be_swapped):
		player.attempt_swap.disconnect(be_swapped)
		player = null

func be_swapped():
	type = player.swap_pickup(type)
	set_sprite()

# has been collected
func be_collected():
	collected.emit() # exclaim
	queue_free() # die
