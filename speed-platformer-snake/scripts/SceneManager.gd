class_name SceneManager
extends Node

## Manager for SceneRoot

var current_scene : SCENES_ENUM
var is_paused := false # pause menu open?

enum SCENES_ENUM {
	mainmenu,
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
}

## initialize game
func _ready() -> void:
	clear_child_scenes() # ensure no children
	AudioManager.scenemanager = self # give audio manager reference
	##Globals.blink_used = false # Resets if player used blink ability
	# load into main menu
	main_menu()

func start_game(): # called from main menu
	MusicManager.set_state(MusicManager.STATE.GAMEPLAY)
	current_scene = SCENES_ENUM.gameplay
	Globals.blink_used = false # Resets if player used blink ability
	_switch_scene(SCENES.get("gameplay"))

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
	_switch_scene(SCENES.get("tutorial"))

func main_menu():
	MusicManager.set_state(MusicManager.STATE.MAIN_MENU)
	current_scene = SCENES_ENUM.mainmenu
	_switch_scene(SCENES.get("main_menu"))

func game_over():
	MusicManager.set_state(MusicManager.STATE.GAME_OVER)
	current_scene = SCENES_ENUM.gameover
	_switch_scene(SCENES.get("game_over"))

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
