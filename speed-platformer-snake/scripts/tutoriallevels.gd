extends "res://scripts/level.gd"

## TUTORIAL LEVELS
## Holds the room list for tutorial runs.
## Edit tutorial_room_paths to control order/content of tutorial levels.

@export_dir var tutorial_room_dir := "res://scenes/rooms/tutorial"

@export var tutorial_room_paths: Array[String] = [
]

var tutorial_rooms: Array[PackedScene] = []
var tutorial_room_index := 0

func _ready() -> void:
	tutorial_rooms.clear()

	if tutorial_room_paths.is_empty():
		for room_scene in load_rooms_from_dir(tutorial_room_dir):
			if room_scene is PackedScene:
				tutorial_rooms.append(room_scene)
	else:
		for room_path in tutorial_room_paths:
			var loaded_scene := load(room_path)
			if loaded_scene is PackedScene:
				tutorial_rooms.append(loaded_scene)
			else:
				push_warning("Tutorial room path failed to load: %s" % room_path)

	if tutorial_rooms.is_empty():
		push_warning("No tutorial rooms loaded, falling back to regular room list.")
		for room_scene in load_rooms_from_dir("res://scenes/rooms/regular"):
			if room_scene is PackedScene:
				tutorial_rooms.append(room_scene)

	super._ready()

func next_room():
	clear_room()

	var skip_trans := true if not current_room else false

	if tutorial_rooms.is_empty():
		return

	var room_scene := tutorial_rooms[tutorial_room_index % tutorial_rooms.size()]
	tutorial_room_index += 1

	current_room = room_scene.instantiate()
	room_root.add_child(current_room)

	if not skip_trans:
		fade_room_out()
		await room_faded_out
		fade_room_in()
