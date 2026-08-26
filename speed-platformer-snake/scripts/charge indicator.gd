extends Control

## CHARGE INDICATOR
# child references
@export var charge_1 : AnimatedSprite2D
@export var charge_2 : AnimatedSprite2D
@export var charge_3 : AnimatedSprite2D

@onready var charge_indicators = [charge_1, charge_2, charge_3,]

# track old charges
var previous_charge_count := 3

# shake
var shake_count := 6
var shake_interval := 0.05

func allign_charges(charge_count : int): # display charges by amount player has
	for i in charge_indicators.size():
		if i < charge_count: # iterate until over charge count
			set_on(charge_indicators[i])
		elif i == charge_count:
			set_charging(charge_indicators[i]) # only shake if newly lost
		else:
			var is_spent = i >= previous_charge_count # only shake if newly lost
			set_off(charge_indicators[i], is_spent)
	previous_charge_count = charge_count

func set_on(indicator : AnimatedSprite2D): 
	indicator.play("charged") # sets texture to on

func set_charging(indicator : AnimatedSprite2D): 
	indicator.play("charging") # sets texture to on

func set_off(indicator: AnimatedSprite2D, skip_shake: bool = false):
	indicator.play("uncharged") # off texture
	if not skip_shake:
		shake(indicator)

# courtesy of claude ai
func shake(node: AnimatedSprite2D) -> void:
	var original_pos := node.position
	for i in shake_count:
		node.position = original_pos + Vector2(randf_range(-3, 3), randf_range(-3, 3))
		await get_tree().create_timer(shake_interval).timeout
	node.position = original_pos
