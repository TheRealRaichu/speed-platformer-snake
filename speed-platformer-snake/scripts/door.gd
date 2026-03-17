class_name Door
extends Node2D

@onready var box := $StaticBody2D
@onready var body := $ColorRect

@export var button : ButtonSwitch

func _ready() -> void:
	button.activated.connect(open)

func open():
	body.visible = false
	box.set_collision_layer_value(1, false)
