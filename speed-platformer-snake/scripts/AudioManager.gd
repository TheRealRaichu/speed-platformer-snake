extends Node

## AUDIO MANAGER

# exceptions
var wall_slide_player := AudioStreamPlayer.new()
var wall_slide_playing := false
var scarf_collision_player := AudioStreamPlayer.new()
var scarf_collision_playing := false


var SOUNDS := {  # sounds dict for grabbing
	# game
	"campfire" : "res://assets/sfx/game/campfire.mp3",
	"button" : "res://assets/sfx/game/button.wav",
	"fueldeposit" : "res://assets/sfx/game/fueldeposit.wav",
	"fuelpickup" : "res://assets/sfx/game/fuelpickup.mp3",
	"pickup" : "res://assets/sfx/game/pickup.mp3",
	"useblinkrestore" : "res://assets/sfx/game/useblinkrestore.wav",
	"usescarfreeler" : "res://assets/sfx/game/usescarfreeler.mp3",
	"usesugar" : "res://assets/sfx/game/usesugar.mp3",
	# menu
	"back" : "res://assets/sfx/menu/back.wav",
	"navigation" : "res://assets/sfx/menu/navigation.wav",
	"select" : "res://assets/sfx/menu/select.wav",
	# player
	"blink" : "res://assets/sfx/player/blink.mp3",
	"deathfreeze" : "res://assets/sfx/player/deathfreeze.mp3",
	"jump" : "res://assets/sfx/player/jump.wav",
	"scarfcollision" : "res://assets/sfx/player/scarfcollision.mp3",
	"step" : "res://assets/sfx/player/step.mp3",
	"walljump" : "res://assets/sfx/player/walljump.mp3",
	"wallslide" : "res://assets/sfx/player/wallslide.mp3",
}

func _ready() -> void:
	# load sounds for special streams
	wall_slide_player.stream = load(SOUNDS.get("wallslide"))
	wall_slide_player.volume_db = 2
	add_child(wall_slide_player)
	scarf_collision_player.stream = load(SOUNDS.get("scarfcollision"))
	scarf_collision_player.volume_db = 4
	add_child(scarf_collision_player)

# create and configure audio stream for this sound effect
func play(sound : String, volume_db: float = 0.0):
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.finished.connect(func(): player.queue_free()) # die when done
	player.stream = load(SOUNDS.get(sound))
	player.volume_db = volume_db
	player.play()
	player.play()

# continuous and looping sounds need their own treatment <3
func play_wall_slide(playing : bool):
	wall_slide_playing = playing # set flag

func play_scarf_reeler(playing : bool):
	scarf_collision_playing = playing # set flag

func _process(_delta: float) -> void:
	# wall slide player
	if wall_slide_playing and not wall_slide_player.playing: # if should be playing and isn't
		wall_slide_player.play() # play
	elif not wall_slide_playing and wall_slide_player.playing: # shouldn't be playing and is, stop
		wall_slide_player.stop() # stop
	
	# scarf collision player
	if scarf_collision_playing and not scarf_collision_player.playing: # if should be playing and isn't
		scarf_collision_player.play() # play
	elif not scarf_collision_playing and scarf_collision_player.playing: # shouldn't be playing and is, stop
		scarf_collision_player.stop() # stop

# VOLUME CONTROL
# courtesy of claude ai

const MASTER_BUS := "Master"
const VOLUME_STEP := 5.0 # db per increase/decrease
const MIN_VOLUME := -80.0
const MAX_VOLUME := 0.0
var muted := false
var volume_before_mute := 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("increase_volume"):
		increase_volume()
	if event.is_action_pressed("decrease_volume"):
		decrease_volume()
	if event.is_action_pressed("mute"):
		toggle_mute()

func increase_volume() -> void:
	var bus := AudioServer.get_bus_index(MASTER_BUS)
	var current := AudioServer.get_bus_volume_db(bus)
	AudioServer.set_bus_volume_db(bus, clamp(current + VOLUME_STEP, MIN_VOLUME, MAX_VOLUME))

func decrease_volume() -> void:
	var bus := AudioServer.get_bus_index(MASTER_BUS)
	var current := AudioServer.get_bus_volume_db(bus)
	AudioServer.set_bus_volume_db(bus, clamp(current - VOLUME_STEP, MIN_VOLUME, MAX_VOLUME))

func toggle_mute() -> void:
	var bus := AudioServer.get_bus_index(MASTER_BUS)
	if muted:
		AudioServer.set_bus_volume_db(bus, volume_before_mute)
		muted = false
	else:
		volume_before_mute = AudioServer.get_bus_volume_db(bus)
		AudioServer.set_bus_volume_db(bus, MIN_VOLUME)
		muted = true
