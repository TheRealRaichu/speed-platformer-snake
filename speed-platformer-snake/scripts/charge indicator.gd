extends Control

## CHARGE INDICATOR
# child references
@onready var charge_1 := $"charge 1"
@onready var charge_2 := $"charge 2"
@onready var charge_3 := $"charge 3"

@onready var charge_indicators = [charge_1, charge_2, charge_3,]

func allign_charges(charge_count : int): # display charges by amount player has
	for i in charge_indicators.size():
		if i < charge_count: # iterate until over charge count
			set_on(charge_indicators[i])
		else:
			set_off(charge_indicators[i])

func set_on(indicator : ColorRect): 
	indicator.color = Color.ORANGE_RED # on sprite

func set_off(indicator : ColorRect):
	indicator.color = Color.DIM_GRAY # off sprite
