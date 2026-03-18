extends Node2D

## LEVEL
# child references
@onready var base := $base
@onready var room_root := $roomroot

# ready
func _ready() -> void:
	# connect signals
	base.fuel_received.connect(base_fuel_received_relay)
	next_room()

# ROOM MANAGER =========

# list of room preloads, are randomly selected from
var rooms := [
	# regular
	preload("res://scenes/rooms/regular/room_1.tscn"),
	preload("res://scenes/rooms/test_2.tscn"),
	# doors
]

var boss_rooms := [
	preload("res://scenes/rooms/blue_fire/blue_fire_1.tscn"),
	preload("res://scenes/rooms/blue_fire/blue_fire_2.tscn"),
]

var pickup_rooms := [
	preload("res://scenes/rooms/pickup/sugar_1.tscn"),
	preload("res://scenes/rooms/pickup/sugar_2.tscn"),
]

# which room list is currently being used
var active_room_list
# use dict to track 3 types of rooms
var previous_room := {} # track previous room so that you dont get 2 in a row

func next_room():
	clear_room() # clear old room
	pick_room_type() # select room type by day and chance
	
	var room = active_room_list.pick_random() # pick random room
	while room == previous_room.get(active_room_list): # make sure room isn't duplicated
		room = active_room_list.pick_random() # repick
	previous_room[active_room_list] = room # room selected, update previous
	
	room_root.add_child(room.instantiate()) # add as child of room root

# called from next room
func pick_room_type():
	# pick room type
	if Globals.day_count % 10 == 0: # if on tenth day of cycle
		active_room_list = boss_rooms # room list is boss rooms
	elif randi_range(1, 5) == 1: # 1/5 chance for any non-boss room to be a pickup room
		active_room_list = pickup_rooms # room list is pickup rooms
	elif Globals.day_count % 5 == 0: # if on fifth day of cycle
		active_room_list = pickup_rooms # room list is pickup rooms
	else: # otherwise
		active_room_list = rooms # set to default list of rooms

func clear_room():
	for child in room_root.get_children(): # clear all children of level
		child.queue_free()

# FUEL ==========

signal base_received_fuel # for whenever fuel is taken

# relay signal from base to game
func base_fuel_received_relay():
	base_received_fuel.emit() # exclaim
	next_room() # room over, call for next room
