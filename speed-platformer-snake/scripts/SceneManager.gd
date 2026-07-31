class_name SceneManager
extends Node

## Manager for SceneRoot

var current_scene : SCENES_ENUM
var is_paused := false # pause menu open?

enum SCENES_ENUM {
	mainmenu,
	game_modes,
	howtoplay,
	settings,
	keybind,
	gameplay,
	tutorial,
	gameover,
}

# SCENE REFERENCES
const SCENES := {
	"main_menu" : preload("res://scenes/main_menu.tscn"),
	"how_to_play" : preload("res://scenes/how_to_play.tscn"),
	"settings" : preload("res://scenes/settings.tscn"),
	"keybind" : preload("res://scenes/keybind.tscn"),
	"gameplay" : preload("res://scenes/game.tscn"),
	"tutorial" : preload("res://scenes/tutorial.tscn"),
	"game_over" : preload("res://scenes/game_over.tscn"),
	"game_modes" : preload("res://scenes/game_modes.tscn"),
}

## initialize game
func _ready() -> void:
	clear_child_scenes() # ensure no children
	AudioManager.scenemanager = self # give audio manager reference
	##Globals.blink_used = false # Resets if player used blink ability
	# load into main menu
	main_menu()

func start_game(): # called from main menu
	MusicManager.set_state(MusicManager.STATE.MAIN_MENU)
	current_scene = SCENES_ENUM.game_modes
	_switch_scene(SCENES.get("game_modes"))

func normal_mode(): # called from game_modes
	MusicManager.set_state(MusicManager.STATE.GAMEPLAY)
	current_scene = SCENES_ENUM.gameplay
	Globals.blink_used = false # Resets if player used blink ability
	next_gameplay_variant = "normal"
	active_gameplay_variant = "normal"
	last_play_mode = "normal"
	_switch_scene(SCENES.get("gameplay"))

func practice_mode(): # called from game_modes
	MusicManager.set_state(MusicManager.STATE.GAMEPLAY)
	current_scene = SCENES_ENUM.gameplay
	Globals.blink_used = false # Resets if player used blink ability
	next_gameplay_variant = "practice"
	active_gameplay_variant = "practice"
	last_play_mode = "practice"
	_switch_scene(SCENES.get("gameplay"))

var next_gameplay_variant := "normal"
var active_gameplay_variant := "normal"
var last_play_mode := "normal"

func two_player_mode(): # called from game_modes
	push_warning("2 player mode is not implemented yet.")

func how_to_play(): # called from main menu
	MusicManager.set_state(MusicManager.STATE.MAIN_MENU)
	current_scene = SCENES_ENUM.howtoplay
	_switch_scene(SCENES.get("how_to_play"))

func settings(): # called from main menu
	MusicManager.set_state(MusicManager.STATE.MAIN_MENU)
	current_scene = SCENES_ENUM.settings
	_switch_scene(SCENES.get("settings"))

func keybind(): # called from settings
	MusicManager.set_state(MusicManager.STATE.MAIN_MENU)
	current_scene = SCENES_ENUM.keybind
	_switch_scene(SCENES.get("keybind"))

func start_tutorial(): # called from how to play
	MusicManager.set_state(MusicManager.STATE.GAMEPLAY)
	current_scene = SCENES_ENUM.tutorial
	Globals.blink_used = false # Resets if player used blink ability
	last_play_mode = "tutorial"
	_switch_scene(SCENES.get("tutorial"))

func main_menu():
	MusicManager.set_state(MusicManager.STATE.MAIN_MENU)
	current_scene = SCENES_ENUM.mainmenu
	_switch_scene(SCENES.get("main_menu"))

func game_over():
	MusicManager.set_state(MusicManager.STATE.GAME_OVER)
	current_scene = SCENES_ENUM.gameover
	_switch_scene(SCENES.get("game_over"))

func restart_current_mode():
	if last_play_mode == "tutorial":
		start_tutorial()
		return

	if active_gameplay_variant == "practice":
		practice_mode()
	else:
		normal_mode()

func _switch_scene(scene : Variant):
	get_tree().paused = false # unpause game
	is_paused = false # set flag
	clear_child_scenes() 
	var inst_scene = scene.instantiate() # instantiate scene
	inst_scene.scene_manager = self # set scene manager reference
	add_child(inst_scene) # add as child to scene root

func clear_child_scenes():
	for child in get_children():
		child.queue_free()
