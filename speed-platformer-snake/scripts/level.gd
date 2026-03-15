extends Node2D

## LEVEL

@onready var base = $base


var rooms := [
	
]

signal base_recieved_fuel

func _ready() -> void:
	# connect signals
	base.fuel_recieved.connect(base_fuel_recieved_relay)

func base_fuel_recieved_relay():
	base_recieved_fuel.emit()
