extends Control

# exports
@export var leaderboard_script : Script
@export var leaderboard_entry_scene : PackedScene
var leaderboard : Leaderboard # for instantiated script
@export var entries : VBoxContainer
@export var register_score_button : Button

# leaderboard display
const DISPLAY_PER_PAGE := 7
var current_page := 0

# score registration
var earned_score : int
const MAX_CHARACTERS = 7


func _ready() -> void:
	# enable score register if score is there
	if earned_score > 0:
		register_score_button.disabled = false
	initialize_leaderboard_script()
	display_leaderboard()

func initialize_leaderboard_script():
	leaderboard = leaderboard_script.new()
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
	pass
