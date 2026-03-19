extends Node

## Manager for SceneRoot

# SCENE REFERENCES
const SCENES := {
	"main_menu" : preload("res://scenes/main_menu.tscn"),
	"game" : preload("res://scenes/game.tscn"),
	"game_over" : preload("res://scenes/game_over.tscn"),
}

## initialize game
func _ready() -> void:
	clear_child_scenes() # ensure no children
	# load into main menu
	switch_scene(SCENES.get("main_menu"))

func start_game(): # called from main menu
	switch_scene(SCENES.get("game"))

func game_over():
	switch_scene(SCENES.get("game_over"))

func switch_scene(scene : Variant):
	clear_child_scenes()
	var inst_scene = scene.instantiate() # instantiate scene
	inst_scene.scene_manager = self # set scene manager reference
	add_child(inst_scene) # add as child to scene root

func clear_child_scenes():
	for child in get_children():
		child.queue_free()
