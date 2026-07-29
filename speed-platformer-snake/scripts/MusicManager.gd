extends Node

## MUSIC MANAGER
## Autoload - plays all stems in sync, mixes dynamically by game state
## courtesy of claude ai

enum STATE {
	MAIN_MENU,   # piano + pads
	GAMEPLAY,    # piano + pad + drums
	GAMEPLAY_BLUE_FIRE, # gameplay + tamb
	GAME_OVER,   # piano only
}

const FADE_DURATION := 1.0 # crossfade time between states
const PAUSE_FADE_DURATION := 0.3
const TARGET_VOLUME := 1.0
const MUTE_VOLUME := -80.0

const MUSIC_BUS := "Music"
const LOWPASS_EFFECT_IDX := 0 # index of the lowpass effect on the bus

# stem players
@onready var piano := $piano
@onready var drums_bass := $drums_bass
@onready var backing := $backing
@onready var tamb := $tamb

func _ready() -> void:
	# start all stems in sync, muted until set_state is called
	piano.play()
	drums_bass.play()
	backing.play()
	tamb.play()
	# start silent or proper volume
	piano.volume_db = TARGET_VOLUME
	drums_bass.volume_db = MUTE_VOLUME
	backing.volume_db = TARGET_VOLUME
	tamb.volume_db = MUTE_VOLUME
	set_paused(false) # set not paused

func set_state(state: STATE) -> void:
	match state: # states are managed by scene switcher, other than blue fire
		STATE.MAIN_MENU:
			fade(piano, TARGET_VOLUME)
			fade(drums_bass, MUTE_VOLUME)
			fade(backing, TARGET_VOLUME)
			fade(tamb, MUTE_VOLUME)
		STATE.GAMEPLAY:
			fade(piano, TARGET_VOLUME)
			fade(drums_bass, TARGET_VOLUME)
			fade(backing, TARGET_VOLUME)
			fade(tamb, MUTE_VOLUME)
		STATE.GAMEPLAY_BLUE_FIRE: # set from base.gd
			fade(piano, TARGET_VOLUME)
			fade(drums_bass, TARGET_VOLUME)
			fade(backing, TARGET_VOLUME)
			fade(tamb, TARGET_VOLUME)
		STATE.GAME_OVER:
			fade(piano, TARGET_VOLUME)
			fade(drums_bass, MUTE_VOLUME)
			fade(backing, MUTE_VOLUME)
			fade(tamb, MUTE_VOLUME)

func fade(player: AudioStreamPlayer, target_volume: float) -> void:
	var tween := create_tween()
	tween.tween_property(player, "volume_db", target_volume if target_volume > 0 else -80.0, FADE_DURATION).set_trans(Tween.TRANS_SINE)

func set_paused(paused: bool) -> void:
	var bus_idx := AudioServer.get_bus_index(MUSIC_BUS)
	var effect := AudioServer.get_bus_effect(bus_idx, LOWPASS_EFFECT_IDX) as AudioEffectLowPassFilter
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(effect, "cutoff_hz", 500.0 if paused else 20500.0, PAUSE_FADE_DURATION)
