extends Control

@onready var label := $Label

# update indicator based on held pickup
func show_pickup(type : Globals.PICKUP_TYPES): 
	match type:
		Globals.PICKUP_TYPES.NULL:
			label.text = ""
		Globals.PICKUP_TYPES.SUGAR:
			label.text = "S"
