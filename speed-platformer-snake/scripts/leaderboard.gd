extends Node
class_name Leaderboard

var score_data : Dictionary = {}

var leaderboard_file := ConfigFile.new()
const leaderboard_filepath := "user://scores.cfg"

func _ready() -> void:
	_open_file()
	
	#test_add_entries()
	
	_load_leaderboard_data() # load data into score_data

func _open_file() -> bool:
	var err = leaderboard_file.load(leaderboard_filepath) # load leaderboard onto file
	# return integrity
	return err == OK

## loads leaderboard data into a local dictionary
func _load_leaderboard_data():
	for player in leaderboard_file.get_sections():
		var player_name = leaderboard_file.get_value(player, "player_name")
		var player_score = leaderboard_file.get_value(player, "player_score")
		score_data[player_name] = player_score

## add a leaderboard entry based on a name
func add_leaderboard_entry(player_name : String, score : int):
	# try to get section from player name
	var section = _get_section_from_key(player_name)
	if section == null: # if player isn't registered yet
		section = _get_new_section()
	# add entry
	leaderboard_file.set_value(section, player_name, score)
	save()

## gets a unique section ID for new registers
func _get_new_section():
	# sections are titled 'Player[section_number]'
	# a new section would have a new number on increment
	var section_count := len(leaderboard_file.get_sections())
	return "Player" + str(section_count) # 'Player#'

## find a section ID from a player name or returns null
func _get_section_from_key(player_name) -> Variant:
	for section in leaderboard_file.get_sections():
		if leaderboard_file.has_section_key(section, player_name):
			return section
	# section not found
	return null

func get_score_data() -> Dictionary:
	_load_leaderboard_data()
	return score_data

func save():
	leaderboard_file.save(leaderboard_filepath)

func test_add_entries():
	for i in range(50):
		add_leaderboard_entry(str(i), i)
