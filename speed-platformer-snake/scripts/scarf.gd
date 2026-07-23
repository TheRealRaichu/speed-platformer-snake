class_name Scarf
extends Node2D

## SCARF
# references
var node_scene := preload("res://scenes/scarf_node.tscn")

# node properties
var node_activation_time := 1 # time to activate in seconds
var node_lifespan := 1.5 # total lifespan of a node, determines length of scarf
var node_lifespan_increment := .2 # amount of time to increment node lifespan by
const NODE_POS_OFFSET = Vector2(0, -16)
# style
var pixel_offset := 4

# manager properties
var nodes : Array[ScarfNode] = [] # list of all nodes
var reeling := false
var reel_accumulator := 0.0
const REEL_RATE := 200.0 # nodes killed per second

func create_node():
	var node_instance := node_scene.instantiate() # create instance
	node_instance.lifespan = node_lifespan # set lifespan attribute
	node_instance.activation_time = node_activation_time # set lifespan activation time
	node_instance.connect("lifespan_over", kill_node) # connect signal
	
	var current_pos := self.global_position + NODE_POS_OFFSET
	var start_pos : Vector2
	if nodes:
		var prev_point := nodes[-1].get_point_position(1) # get second point of last node
		var dir := (current_pos - prev_point).normalized() # normalize the difference
		start_pos = prev_point - dir * pixel_offset # extend back by 4 pixels
	else:
		start_pos = current_pos
	
	node_instance.add_point(start_pos)
	node_instance.add_point(current_pos)
	
	nodes.push_back(node_instance) # log node in list
	add_child(node_instance) # add child

func increment_node_lifespan(): # increment lifespan
	node_lifespan += node_lifespan_increment

func kill_node(): # remove node from front and kill it
	if nodes.is_empty(): # guard against empty array desync
		return
	var node = nodes.pop_front()
	node.die()

# reel scarf back, called from player
func reel():
	reeling = true

func _physics_process(delta: float) -> void:
	# Freezes the scarf
	if get_tree().paused:
		return
	
	if reeling:
		reel_accumulator += delta * REEL_RATE
		while reel_accumulator >= 1.0 and nodes:
			kill_node()
			reel_accumulator -= 1.0
		if nodes.is_empty():
			reeling = false
			reel_accumulator = 0.0
	
	create_node() # create every tick
