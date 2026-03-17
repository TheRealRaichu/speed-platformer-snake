extends Node2D

## LEVEL

@onready var base := $base
@onready var room_root := $roomroot

var rooms := [
	preload("res://scenes/rooms/test_1.tscn"),
	preload("res://scenes/rooms/test_2.tscn"),
	preload("res://scenes/rooms/test_3.tscn"),
]

var previous_room # track previous room so that you dont get 2 in a row

signal base_recieved_fuel

func _ready() -> void:
	# connect signals
	base.fuel_recieved.connect(base_fuel_recieved_relay)
	next_room()

func base_fuel_recieved_relay():
	base_recieved_fuel.emit()
	next_room()

func next_room():
	clear_room()
	var room = rooms.pick_random() # pick random room
	while room == previous_room: # make sure room isn't duplicated
		room = rooms.pick_random() # repick
	previous_room = room # room selected, update previous
	
	room_root.add_child(room.instantiate())

func clear_room():
	for child in room_root.get_children(): # clear all children of level
		child.queue_free()
