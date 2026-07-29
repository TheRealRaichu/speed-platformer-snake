extends Control

## DAY COUNTER

# child references
@onready var day_count = $"day count"
@onready var score_reaction = $"HBoxContainer/score reaction"
@onready var plusses := $"HBoxContainer/plusses"

const SCORE_REACTION_DURATION := 2 # time in seconds score reaction displays

# set day count to given integer
func set_day_count(day_count_num : int, quick := false, blinkless := false):
	update_label(day_count_num, quick, blinkless)

func update_label(day_count_num : int, quick := false, blinkless := false):
	day_count.text = str(day_count_num) # set day count label
	check_label_sizing()
	set_score_reaction_text(quick, blinkless)
	get_tree().create_timer(SCORE_REACTION_DURATION).timeout.connect(func(): score_reaction.text = ""; plusses.text = "") # wait for score reaction duration and reset label

func set_score_reaction_text(quick : bool, blinkless : bool):
	if quick and blinkless:
		score_reaction.text = "Masterful!!!"
		plusses.text = "|||"
	elif quick:
		score_reaction.text = "Quick!!"
		plusses.text = "||"
	elif blinkless:
		score_reaction.text = "Blinkless?!"
		plusses.text = "||"
	else:
		score_reaction.text = "Survived!"
		plusses.text = "|"

# ensure that font size is appropriate for number of digits
func check_label_sizing():
	if day_count.text.length() > 2:
		day_count.add_theme_font_size_override("font_size", 16)
	else:
		day_count.add_theme_font_size_override("font_size", 24)
