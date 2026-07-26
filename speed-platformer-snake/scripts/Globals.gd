extends Node

## AUTOLOADED REFERENCE FOR GLOBAL VARIABLES

var day_count := 1 # how many days survived, start at one for day one
var score := 1 # score that gets displayed
var blink_used := false
var up_input_is_jump := false

# Shared map for keybind menu row-to-action wiring.
const KEYBIND_ROW_ACTIONS := {
	"Keybind_Up": "move_up",
	"Keybind_Down": "move_down",
	"Keybind_Right": "move_right",
	"Keybind_Left": "move_left",
	"Keybind_Jump": "jump",
	"Keybind_Blink": "ability",
	"Keybind_Item": "use_item",
	"Keybind_Mute": "mute",
	"Keybind_DecreaseVolume": "decrease_volume",
	"Keybind_IncreaseVolume": "increase_volume",
	"Keybind_Pause": "ui_cancel",
}

# make sure to update with the list in pickup.gd as well
enum PICKUP_TYPES {
	NULL,
	FUEL,
	SUGAR,
	SCARF_REELER,
	PACKAGED_FUEL,
	BLINK_RESTORE,
	# etc..
}
