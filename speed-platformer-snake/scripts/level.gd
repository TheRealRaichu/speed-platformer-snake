extends Node2D

## LEVEL
# child references
@onready var base := $base
@onready var room_root := $roomroot
@onready var border := $border
@onready var darkness_mask := $mask

# ready
func _ready() -> void:
	# connect signals
	base.fuel_received.connect(base_fuel_received_relay)
	base.died_out.connect(base_died_out_relay)
	next_room() # immediate begin next room
	

# ROOM MANAGER =========

var current_room # current room loaded by level

# list of room preloads, are randomly selected from
var rooms := [
	# regular
	preload("res://scenes/rooms/regular/room_1.tscn"),
	preload("res://scenes/rooms/test_2.tscn"),
	# doors

	## For Testing
	#preload("res://scenes/rooms/Testing/test_4.tscn"),
	#preload("res://scenes/rooms/Testing/test_3.tscn"),
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
	# fade old room out
	clear_room() # clear old room
	
	var skip_trans = true if not current_room else false
	
	# insert new room
	pick_room_type() # select room type by day and chance
	
	var room = active_room_list.pick_random() # pick random room
	while room == previous_room.get(active_room_list): # make sure room isn't duplicated
		room = active_room_list.pick_random() # repick
	previous_room[active_room_list] = room # room selected, update previous
	
	current_room = room.instantiate()
	room_root.add_child(current_room) # add as child of room root
	
	if not skip_trans: # if there was room before
		fade_room_out() # fade out animation
		await room_faded_out # wait for room to finish fading out
		fade_room_in() # fade new room in


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

# ROOM TRANSITION ======

const ROOM_FADE_OUT_TIME := .4
const NIGHT_DURATION := 0.0
const ROOM_FADE_IN_TIME := .8

signal room_faded_out
signal room_faded_in

func fade_room_out():
	# overlay
	var darkness_tween = create_tween()
	darkness_tween.tween_property(darkness_mask, "modulate:a", 0.5, ROOM_FADE_OUT_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN) # fade to black
	darkness_tween.tween_interval(NIGHT_DURATION) # hold at black
	
	# modulate level
	var level_modulate_tween = create_tween()
	level_modulate_tween.tween_property(border, "modulate:g", 0.5, ROOM_FADE_OUT_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN) # fade to black
	level_modulate_tween.tween_interval(NIGHT_DURATION) # hold at black
	
	# modulate room
	var room_modulate_tween = create_tween()
	room_modulate_tween.tween_property(current_room, "modulate:g", 0.5, ROOM_FADE_OUT_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN) # fade to black
	room_modulate_tween.tween_interval(NIGHT_DURATION) # hold at black
	
	# TODO ALSO DO SKY BACKGROUND TRANSITION
	
	await darkness_tween.finished
	
	room_faded_out.emit()

func fade_room_in():
	# overlay
	var darkness_tween = create_tween()
	darkness_tween.tween_property(darkness_mask, "modulate:a", 0.0, ROOM_FADE_OUT_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT) # fade to black
	
	# modulate level
	var level_modulate_tween = create_tween()
	level_modulate_tween.tween_property(border, "modulate:g", 1.0, ROOM_FADE_OUT_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT) # fade to black
	
	# modulate room
	current_room.modulate.g = 0.5 # set new room's modulate g to prev value
	var room_modulate_tween = create_tween()
	room_modulate_tween.tween_property(current_room, "modulate:g", 1.0, ROOM_FADE_OUT_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT) # fade to black
	
	# TODO ALSO DO SKY BACKGROUND TRANSITION
	
	await darkness_tween.finished
	
	room_faded_in.emit()

# BASE ==========

signal base_received_fuel # for whenever fuel is taken
signal base_died_out # when base dies

# relay signal from base to game
func base_fuel_received_relay():
	base_received_fuel.emit() # exclaim
	next_room() # room over, call for next room

func base_died_out_relay():
	base_died_out.emit() # base is dead
