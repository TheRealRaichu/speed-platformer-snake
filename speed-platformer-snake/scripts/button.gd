class_name ButtonSwitch
extends Node2D

## BUTTON
# child references
# temp
@onready var sprite := $AnimatedSprite2D

# colors for color coding buttons and doors
enum COLORS {
	RED,
	GREEN,
	YELLOW,
	BLUE,
}

# convert color enum to animation name suffix
var color_to_suffix := {COLORS.RED : "_red", COLORS.GREEN : "_green", COLORS.BLUE : "_blue", COLORS.YELLOW : "_yellow"}

var color : COLORS # current color, taken from door

signal activated

func _ready() -> void:
	sprite.play("inactive" + color_to_suffix.get(color))

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # if body is player
		activate()

func activate():
	sprite.play("active" + color_to_suffix.get(color))
	activated.emit() # exclaim

func set_color(set_color : int):
	color = set_color
