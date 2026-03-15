class_name Pickup
extends Node2D

# child references
@onready var area = $Area2D # reference to area for player detection

@export var type : PICKUP_TYPES # globals contains all pickup types

enum PICKUP_TYPES {
	FUEL,
	SUGAR,
	# etc..
}

signal collected # emitted when pickup is collected

func _process(delta: float) -> void:
	# check for player in range
	for body in area.get_overlapping_bodies():
		if not body.is_in_group("player"): # if object is not player
			continue # skip to next iteration
		
		var accepeted := false # is accepted by player?
		 # if pickup is fuel
		if type == PICKUP_TYPES.FUEL: 
			accepeted = body.attempt_recieve_fuel() # returns true if player takes fuel
		# is pickup of another type
		else: accepeted = body.attempt_recieve_pickup(type) # returns true if player takes pickup
		if accepeted: be_collected() # self is collected if player has accepted it

# has been collected
func be_collected():
	collected.emit() # exclaim
	queue_free() # die
