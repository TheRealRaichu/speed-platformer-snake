extends Control

## DEBUG UI
# player reference
@export var player : Player

@onready var right_buf := $"right buffer"
@onready var left_buf := $"left buffer"
@onready var jump_buf := $"jump buffer"

func _process(delta: float) -> void:

	right_buf.add_theme_color_override("font_color", Color.RED)
	left_buf.add_theme_color_override("font_color", Color.RED) 
	jump_buf.add_theme_color_override("font_color", Color.RED) 
	if player.right_buffer: right_buf.add_theme_color_override("font_color", Color.GREEN)
	if player.left_buffer: left_buf.add_theme_color_override("font_color", Color.GREEN)
	if player.jump_buffer: jump_buf.add_theme_color_override("font_color", Color.GREEN)
