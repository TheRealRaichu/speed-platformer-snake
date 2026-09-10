extends Menu
class_name LeaderboardUI

# exports
@export var leaderboard_script : Script
@export var leaderboard_entry_scene : PackedScene
var leaderboard : Leaderboard # for instantiated script
@export var entries : VBoxContainer
@export var register_score_button : Button
@export var leaderboard_register_scene : PackedScene
@export var close_button : Button

# leaderboard display
const DISPLAY_PER_PAGE := 7
var current_page := 0

# score registration
var earned_score : int # for storage and checking if score exists for registry
const MAX_CHARACTERS = 7

signal closed # when leaderboard is quit; undims screen behind it etc

func _ready() -> void:
	close_button.grab_focus()
	# enable score register if score is there
	if earned_score > 0:
		register_score_button.disabled = false
	
	initialize_leaderboard_script()
	display_leaderboard()

func initialize_leaderboard_script():
	if leaderboard: leaderboard.queue_free()
	leaderboard = leaderboard_script.new() as Leaderboard
	add_child(leaderboard)

func display_leaderboard(page : int = 0):
	current_page = page
	clear_entries()
	
	var score_data = leaderboard.get_score_data() as Dictionary
	var all_keys = score_data.keys()
	# slice boundaries
	var start_index = current_page * DISPLAY_PER_PAGE
	var end_index = min(start_index + DISPLAY_PER_PAGE, len(all_keys))
	
	for i in range(start_index, end_index):
		var player_name = all_keys[i]
		
		if player_name == null: continue # skip nulls
		
		var leaderboard_entry_inst = leaderboard_entry_scene.instantiate()
		leaderboard_entry_inst.player_name = player_name
		leaderboard_entry_inst.player_score = score_data[player_name]
		entries.add_child(leaderboard_entry_inst)

func next_page() -> void:
	if current_page + 1 < get_page_count():
		display_leaderboard(current_page + 1)

func previous_page() -> void:
	if current_page > 0:
		display_leaderboard(current_page - 1)

func clear_entries():
	for child in entries.get_children():
		child.queue_free()

func get_page_count() -> int:
	return (len((leaderboard.get_score_data().keys())) + (DISPLAY_PER_PAGE-1))/DISPLAY_PER_PAGE

func register_score() -> void:
	var leaderboard_register_inst = leaderboard_register_scene.instantiate() as LeaderboardRegister
	leaderboard_register_inst.name_confirm.connect(accept_name)
	enbacken(true)
	add_sibling(leaderboard_register_inst)

func accept_name(name : String):
	enbacken(false)
	leaderboard.add_leaderboard_entry(name, earned_score)
	initialize_leaderboard_script()
	display_leaderboard()
	close_button.grab_focus()

func _on_close_pressed() -> void:
	closed.emit()
	die()

func die():
	queue_free()
