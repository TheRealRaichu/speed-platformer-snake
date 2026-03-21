class_name Scarf
extends Node2D

## SCARF
# references
var node_scene := preload("res://scenes/scarf_node.tscn")

# node properties
var NODE_ACTIVATION_TIME := 1 # time to activate in seconds
var NODE_LIFESPAN := 1.5 # total lifespan of a node, determines length of scarf
var NODE_LIFESPAN_INCREMENT := .2 # amount of time to increment node lifespan by
const NODE_POS_OFFSET = Vector2(0, -16)

# manager properties
var nodes : Array[ScarfNode] = [] # list of all nodes
var reeling_kill_interval # how quickly to kill nodes when reeling

func create_node():
	var node_instance := node_scene.instantiate() # create instance
	node_instance.lifespan = NODE_LIFESPAN # set lifespan attribute
	node_instance.activation_time = NODE_ACTIVATION_TIME # set lifespan activation time
	node_instance.connect("lifespan_over", kill_node) # connect signal
	
	var current_pos := self.global_position + NODE_POS_OFFSET
	var start_pos : Vector2
	if nodes:
		var prev_point := nodes[-1].get_point_position(1)
		var dir := (current_pos - prev_point).normalized()
		start_pos = prev_point - dir * 4 # extend back by 4 pixels
	else:
		start_pos = current_pos
	
	node_instance.add_point(start_pos)
	node_instance.add_point(current_pos)
	
	nodes.push_back(node_instance) # log node in list
	add_child(node_instance) # add child

func increment_node_lifespan(): # increment lifespan
	NODE_LIFESPAN += NODE_LIFESPAN_INCREMENT

func kill_node(): # remove node from front and kill it
	var node = nodes.pop_front()
	node.die()

# reel scarf back, called from player
func reel():
	# quickly kill all victims
	var has_nodes := true
	while has_nodes: # while children exist
		kill_node() # kill them all
		await get_tree().create_timer(0.0001, false).timeout # wait a small bit
		has_nodes = true if get_children() else false

func _physics_process(_delta: float) -> void:
	# Freezes the scarf
	if get_tree().paused:
		return
	
	create_node() # create every tick
