extends Node

## AUDIO MANAGER

# exceptions
var wall_slide_player := AudioStreamPlayer.new()
var wall_slide_playing := false
var scarf_collision_player := AudioStreamPlayer.new()
var scarf_collision_playing := false


var SOUNDS := {} # sounds dict for grabbing

func _ready() -> void:
	# load sounds from directories
	load_sounds_from_dir("res://assets/sfx/player")
	load_sounds_from_dir("res://assets/sfx/game")
	load_sounds_from_dir("res://assets/sfx/menu")
	# load sounds for special streams
	wall_slide_player.stream = load(SOUNDS.get("wallslide"))
	wall_slide_player.volume_db = 2
	add_child(wall_slide_player)
	scarf_collision_player.stream = load(SOUNDS.get("scarfcollision"))
	scarf_collision_player.volume_db = 4
	add_child(scarf_collision_player)

# loads all sound effects and creates dictionary on startup, courtesy of claude ai 
func load_sounds_from_dir(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file := dir.get_next()
		while file != "":
			if file.ends_with(".mp3") or file.ends_with(".wav") or file.ends_with(".ogg"):
				var key := file.get_basename() # filename without extension = key
				SOUNDS[key] = path + "/" + file
			file = dir.get_next()

# create and configure audio stream for this sound effect
func play(sound : String, volume_db: float = 0.0):
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.finished.connect(func(): player.queue_free()) # die when done
	player.stream = load(SOUNDS.get(sound))
	player.volume_db = volume_db
	player.play()

# continuous and looping sounds need their own treatment <3
func play_wall_slide(playing : bool):
	wall_slide_playing = playing # set flag

func play_scarf_reeler(playing : bool):
	scarf_collision_playing = playing # set flag

func _process(delta: float) -> void:
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
