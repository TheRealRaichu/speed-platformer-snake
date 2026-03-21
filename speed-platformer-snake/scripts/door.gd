class_name Door
extends Node2D

## DOOR

# child ref
@onready var box := $StaticBody2D
@onready var sprite := $AnimatedSprite2D

# exports
@export var button : ButtonSwitch # export for button
@export var color : COLORS # pick color from engine

var is_activated := false # is door activated? 

# colors for color coding buttons and doors
enum COLORS {
	RED,
	GREEN,
	YELLOW,
	BLUE,
}

# convert color enum to animation name suffix
var color_to_suffix := {COLORS.RED : "_red", COLORS.GREEN : "_green", COLORS.BLUE : "_blue", COLORS.YELLOW : "_yellow"}


# Holding a pass temporarily
func _ready() -> void:
	sprite.play("inactive" + color_to_suffix.get(color))
	if button:
		button.activated.connect(open)
		button.set_color(color)

func open():
	if is_activated:
		return # do nothing if already activated
	sprite.play("active" + color_to_suffix.get(color))
	box.set_collision_layer_value(1, false)
	is_activated = true
