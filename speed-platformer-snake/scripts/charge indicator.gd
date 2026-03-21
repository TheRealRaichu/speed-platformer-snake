extends Control

## CHARGE INDICATOR
# child references
@onready var charge_1 := $"charge 1"
@onready var charge_2 := $"charge 2"
@onready var charge_3 := $"charge 3"

@onready var charge_indicators = [charge_1, charge_2, charge_3,]

# track old charges
var previous_charge_count := 3

func allign_charges(charge_count : int): # display charges by amount player has
	for i in charge_indicators.size():
		if i < charge_count: # iterate until over charge count
			set_on(charge_indicators[i])
		else:
			set_off(charge_indicators[i], i >= previous_charge_count) # only shake if newly lost
	previous_charge_count = charge_count

func set_on(indicator : UIText): 
	indicator.focused() # sets texture to on
	

func set_off(indicator: TextureRect, skip_shake: bool = false):
	indicator.unfocused() # off texture
	if not skip_shake:
		shake(indicator)

# courtesy of claude ai
func shake(node: TextureRect) -> void:
	var original_pos := node.position
	for i in 6:
		node.position = original_pos + Vector2(randf_range(-3, 3), randf_range(-3, 3))
		await get_tree().create_timer(0.05).timeout
	node.position = original_pos
