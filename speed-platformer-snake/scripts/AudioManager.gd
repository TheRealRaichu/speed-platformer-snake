extends Node

## AUDIO MANAGER

const SOUNDS := {
	"step" : "res://assets/sfx/player/step.mp3",

}

func play(sound: String, volume_db: float = 0.0):
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(SOUNDS.get(sound))
	player.volume_db = volume_db
	player.play()
