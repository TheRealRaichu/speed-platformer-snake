extends Node

## Manager for SceneRoot

# SCENE REFERENCES
const main_menu_scene := preload("res://scenes/main_menu.tscn")
const game_scene := preload("res://scenes/game.tscn") 

## initialize game
func _ready() -> void:
	clear_child_scenes() # ensure no children
	# load into main menu
	switch_scene(main_menu_scene)

func start_game(): # called from main menu
	switch_scene(game_scene)

func switch_scene(scene : Variant):
	clear_child_scenes()
	var inst_scene = scene.instantiate() # instantiate scene
	inst_scene.scene_manager = self # set scene manager reference
	add_child(inst_scene) # add as child to scene root

func clear_child_scenes():
	for child in get_children():
		child.queue_free()

func _process(_delta: float) -> void:
	
	# temp before pause menu
	if Input.is_action_just_pressed("ui_cancel"): # esc pressed
		get_tree().quit() # quit game
