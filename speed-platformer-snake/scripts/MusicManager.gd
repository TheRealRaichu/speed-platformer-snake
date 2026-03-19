extends Node

## MUSIC MANAGER
## Autoload - plays all stems in sync, mixes dynamically by game state
## courtesy of claude ai

enum STATE {
	MAIN_MENU,   # piano + pads
	GAMEPLAY,    # all stems
	GAME_OVER,   # piano only
}

const FADE_DURATION := 2.0 # crossfade time between states

# stem players
@onready var piano := $piano
@onready var drums_bass := $drums_bass
@onready var elements := $backing

func _ready() -> void:
	# start all stems in sync, muted until set_state is called
	piano.play()
	drums_bass.play()
	elements.play()
	# start silent
	piano.volume_db = linear_to_db(0.0)
	drums_bass.volume_db = linear_to_db(0.0)
	elements.volume_db = linear_to_db(0.0)

func set_state(state: STATE) -> void:
	match state:
		STATE.MAIN_MENU:
			fade(piano, 1.0)
			fade(drums_bass, 0.0)
			fade(elements, 1.0)
		STATE.GAMEPLAY:
			fade(piano, 1.0)
			fade(drums_bass, 1.0)
			fade(elements, 1.0)
		STATE.GAME_OVER:
			fade(piano, 1.0)
			fade(drums_bass, 0.0)
			fade(elements, 0.0)

func fade(player: AudioStreamPlayer, target_volume: float) -> void:
	var tween := create_tween()
	tween.tween_property(player, "volume_db", linear_to_db(target_volume) if target_volume > 0 else -80.0, FADE_DURATION).set_trans(Tween.TRANS_SINE)
