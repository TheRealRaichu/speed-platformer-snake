extends Control

## PICKUP INDICATOR
# child references
@onready var label := $Label

# update indicator based on held pickup
func show_pickup(type : Globals.PICKUP_TYPES): 
	match type:
		Globals.PICKUP_TYPES.NULL:
			label.text = ""
		Globals.PICKUP_TYPES.SUGAR:
			label.text = "S"
		Globals.PICKUP_TYPES.SCARF_REELER:
			label.text = "R"
		Globals.PICKUP_TYPES.PACKAGED_FUEL:
			label.text = "P"
		Globals.PICKUP_TYPES.BLINK_RESTORE:
			label.text = "B"
