extends Node

## AUDIO MANAGER

const SOUNDS := {
	# player
	"step" : "res://assets/sfx/player/step.mp3",
	"jump" : "res://assets/sfx/player/jump.wav",
	"death" : "res://assets/sfx/player/deathfreeze.mp3",
	# game
	"pickup" : "res://assets/sfx/game/pickup.wav",
	"usesugar" : "res://assets/sfx/game/usesugar.mp3",
	"fueldeposit" : "res://assets/sfx/game/fueldeposit.wav",
	"blinkrestore" : "res://assets/sfx/game/blinkrestore.wav",
	"campfire" : "res://assets/sfx/game/campfire.mp3",
	# menu
	"nav" : "res://assets/sfx/menu/navigation.wav",
	"select" : "res://assets/sfx/menu/select.wav",
	"back" : "res://assets/sfx/menu/backbutton.wav",
}

# create and configure audio stream for this sound effect
func play(sound : String, volume_db: float = 0.0):
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(SOUNDS.get(sound))
	player.volume_db = volume_db
	player.play()
