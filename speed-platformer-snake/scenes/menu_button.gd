extends Button

## MENU BUTTON

func _on_pressed() -> void:
	AudioManager.play("select") # play menu select noise

func _on_focus_entered() -> void:
	AudioManager.play("navigation") # play menu nav noise
