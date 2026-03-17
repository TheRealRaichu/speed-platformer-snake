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
	preload("res://scenes/rooms/test_1.tscn"),
	preload("res://scenes/rooms/test_2.tscn"),
]

var boss_rooms := [
	preload("res://scenes/rooms/blue_fire_1.tscn"),
	preload("res://scenes/rooms/blue_fire_2.tscn"),
]

var pickup_rooms := [
	preload("res://scenes/rooms/test_3.tscn"),
]

# use dict to track 3 types of rooms
var previous_room := {} # track previous room so that you dont get 2 in a row


func next_room():
	clear_room()
	var room_list
	if Globals.day_count % 10 == 0: # if on tenth day of cycle
		room_list = boss_rooms # room list is boss rooms
	elif Globals.day_count % 5 == 0: # if on fifth day of cycle
		room_list = pickup_rooms # room list is pickup rooms
	else: # otherwise
		room_list = rooms # set to default list of rooms
	
	var room = room_list.pick_random() # pick random room
	while room == previous_room.get(room_list): # make sure room isn't duplicated
		room = room_list.pick_random() # repick
	previous_room[room_list] = room # room selected, update previous
	
	room_root.add_child(room.instantiate()) # add as child of room root

func clear_room():
	for child in room_root.get_children(): # clear all children of level
		child.queue_free()

# FUEL ==========

signal base_received_fuel # for whenever fuel is taken

# relay signal from base to game
func base_fuel_received_relay():
	base_received_fuel.emit() # exclaim
	next_room() # room over, call for next room
