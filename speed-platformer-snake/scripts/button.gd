class_name ButtonSwitch
extends Node2D

## BUTTON
# child references
# temp
@onready var indicator := $indicator
@onready var button := $button

# colors for color coding buttons and doors
enum COLORS {
	reg
}

var color : COLORS # current color, taken from door
var inactive_palettes := {} # sprites of inactive buttons by color
var active_palettes := {} # sprites of active buttons by color

signal activated

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # if body is player
		activate()

func activate():
	# change sprite
	button.visible = false
	indicator.color = Color.WHITE
	activated.emit() # exclaim
