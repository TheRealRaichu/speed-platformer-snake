extends Node

## AUTOLOADED REFERENCE FOR GLOBAL VARIABLES

var day_count := 1 # how many days survived, start at one for day one
var score := 1 # score that gets displayed
var blink_used := false
var up_input_is_jump := false

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
