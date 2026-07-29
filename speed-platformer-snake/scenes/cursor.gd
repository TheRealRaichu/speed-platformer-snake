extends Control

func _ready() -> void:
	modhide()

# show via modulate
func modshow():
	modulate.a = 1

# hide via modulate
func modhide():
	modulate.a = 0
