extends Control

## DAY COUNTER

# child references
@onready var label = $Label

func _ready() -> void:
	update_label(0) # update on ready

# set day count to given integer
func set_day_count(day_count : int):
	update_label(day_count)

func update_label(day_count : int):
	check_label_sizing()
	label.text = str(day_count)

# ensure that font size is appropriate for number of digits
func check_label_sizing():
	if label.text.length() > 2:
		label.add_theme_font_size_override("font_size", 16)
	else:
		label.add_theme_font_size_override("font_size", 24)
