extends Control

## PICKUP INDICATOR
# child references
@onready var icon := $"pickup icon"
@onready var item_name := $"item name"

# update indicator based on held pickup
func show_pickup(type : Globals.PICKUP_TYPES): 
	match type:
		Globals.PICKUP_TYPES.NULL:
			icon.play("empty")
			item_name.text = ""
		Globals.PICKUP_TYPES.SUGAR:
			icon.play("sugar")
			item_name.text = "Sugar"
		Globals.PICKUP_TYPES.SCARF_REELER:
			icon.play("reeler")
			item_name.text = "Scarf Reeler"
		Globals.PICKUP_TYPES.PACKAGED_FUEL:
			icon.play("packaged_fuel")
			item_name.text = "Port-A-Coal"
		Globals.PICKUP_TYPES.BLINK_RESTORE:
			icon.play("blink_restore")
			item_name.text = "Blink Restore"
