extends Control

## PICKUP INDICATOR
# child references
@onready var icon := $"placeholder icon"
@onready var item_name := $"item name"

# update indicator based on held pickup
func show_pickup(type : Globals.PICKUP_TYPES): 
	match type:
		Globals.PICKUP_TYPES.NULL:
			icon.text = ""
			item_name.text = ""
		Globals.PICKUP_TYPES.SUGAR:
			icon.text = "S"
			item_name.text = "Sugar"
		Globals.PICKUP_TYPES.SCARF_REELER:
			icon.text = "R"
			item_name.text = "Scarf Reeler"
		Globals.PICKUP_TYPES.PACKAGED_FUEL:
			icon.text = "P"
			item_name.text = "Port-A-Coal"
		Globals.PICKUP_TYPES.BLINK_RESTORE:
			icon.text = "B"
			item_name.text = "Blink Restore"
