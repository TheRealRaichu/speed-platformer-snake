extends Control
class_name SettingsUI

var settings_file := ConfigFile.new()
const settings_filepath := "user://settings.cfg"

@export var fullscreen_button : CheckButton
@export var SFX_volume_slider : HSlider
@export var music_volume_slider : HSlider
@export var edit_keybind_button : Button
@export var tap_jump_button : CheckButton
@export var debug_mode_button : CheckButton

@export var closed_button : Button
@export var apply_settings_button : Button

signal closed

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	match toggled_on:
		true:
			get_window().mode = get_window().MODE_FULLSCREEN
		false:
			get_window().mode = get_window().MODE_WINDOWED

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioManager.set_volume(AudioManager.SFX_BUS, value)

func _on_music_volume_value_changed(value: float) -> void:
	AudioManager.set_volume(AudioManager.MUSIC_BUS, value)

func _on_tap_jump_toggled(toggled_on: bool) -> void:
	Globals.tap_jump = toggled_on

func _on_debug_mode_toggled(toggled_on: bool) -> void:
	Globals.debug_mode = toggled_on

func _on_close_pressed() -> void:
	die()

func die():
	queue_free()

func _process(delta: float) -> void:
	SFX_volume_slider.set_value(AudioManager.get_volume(AudioManager.SFX_BUS))
	music_volume_slider.set_value(AudioManager.get_volume(AudioManager.MUSIC_BUS))
