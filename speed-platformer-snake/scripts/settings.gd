extends Control

## SETTINGS
signal back_pressed

var volume_slider: HSlider
var resolution_slider: HSlider
var fullscreen_check: CheckButton
var up_jump_check: CheckButton
var cursor_resolution: Control
var cursor_audio: Control
var cursor_fullscreen: Control
var cursor_up_jump: Control

var settings_back_button: Button

var resolution_text: TextureRect
var audio_text: TextureRect
var settings_back_text: TextureRect
var settings_back_arrow: TextureRect

const RESOLUTIONS := [Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440)]

func _ready() -> void:
	_connect_controls()
	_initialize_settings_controls()

func _connect_controls() -> void:
	volume_slider = get_node("Settings/Audio/AudioControl")
	resolution_slider = get_node("Settings/Resolution/ResolutionControl")
	fullscreen_check = get_node("Settings/Fullscreen/FullScreenCheck")
	up_jump_check = get_node("Settings/UpInputJump/JumpCheck")
	cursor_resolution = get_node("Settings/Resolution/ResolutionControl/ResolutionCursor")
	cursor_audio = get_node("Settings/Audio/AudioControl/AudioCursor")
	cursor_fullscreen = get_node("Settings/Fullscreen/FullScreenCursor")
	cursor_up_jump = get_node("Settings/UpInputJump/JumpCursor")

	settings_back_button = get_node("Settings/BackNode/back")

	resolution_text = get_node("Settings/Resolution/ResolutionControl/ResolutionText")
	audio_text = get_node("Settings/Audio/AudioControl/AudioText")
	settings_back_text = get_node("Settings/BackNode/BackText")
	settings_back_arrow = get_node("Settings/BackNode/TextureRect")

	settings_back_button.focus_entered.connect(_on_settings_back_focus_entered)
	settings_back_button.focus_exited.connect(_on_settings_back_focus_exited)
	settings_back_button.pressed.connect(_on_settings_back_pressed)

	resolution_slider.focus_entered.connect(_on_resolution_focus_entered)
	resolution_slider.focus_exited.connect(_on_resolution_focus_exited)
	volume_slider.focus_entered.connect(_on_audio_focus_entered)
	volume_slider.focus_exited.connect(_on_audio_focus_exited)
	fullscreen_check.focus_entered.connect(_on_fullscreen_focus_entered)
	fullscreen_check.focus_exited.connect(_on_fullscreen_focus_exited)
	up_jump_check.focus_entered.connect(_on_up_jump_focus_entered)
	up_jump_check.focus_exited.connect(_on_up_jump_focus_exited)

	cursor_resolution.visible = false
	cursor_audio.visible = false
	cursor_fullscreen.visible = false
	cursor_up_jump.visible = false

func _initialize_settings_controls() -> void:
	if volume_slider:
		volume_slider.min_value = AudioManager.MIN_VOLUME
		volume_slider.max_value = AudioManager.MAX_VOLUME
		volume_slider.step = 1.0
		volume_slider.value = AudioManager.get_bus_volume_db(AudioManager.MUSIC_BUS)
		volume_slider.value_changed.connect(_on_volume_slider_changed)

	if resolution_slider:
		resolution_slider.min_value = 0
		resolution_slider.max_value = RESOLUTIONS.size() - 1
		resolution_slider.step = 1.0
		resolution_slider.value = _get_current_resolution_index()
		resolution_slider.value_changed.connect(_on_resolution_slider_changed)

	if fullscreen_check:
		fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		fullscreen_check.toggled.connect(_on_fullscreen_toggled)

	if up_jump_check:
		up_jump_check.button_pressed = Globals.up_input_is_jump
		up_jump_check.toggled.connect(_on_up_jump_toggled)

## Called by the main menu script right after this panel is shown.
func focus_back_button() -> void:
	settings_back_button.grab_focus()

func _on_volume_slider_changed(value: float) -> void:
	AudioManager.set_bus_volume_db(AudioManager.MUSIC_BUS, value)

func _on_resolution_focus_entered() -> void:
	cursor_resolution.visible = true
	resolution_text.focused()

func _on_audio_focus_entered() -> void:
	cursor_audio.visible = true
	audio_text.focused()

func _on_fullscreen_focus_entered() -> void:
	cursor_fullscreen.visible = true

func _on_up_jump_focus_entered() -> void:
	cursor_up_jump.visible = true

func _on_settings_back_focus_entered() -> void:
	if settings_back_text and settings_back_text.has_method("focused"):
		settings_back_text.focused()
	elif settings_back_text:
		settings_back_text.texture = preload("res://assets/UI/Buttons/back.png")

func _on_resolution_focus_exited() -> void:
	cursor_resolution.visible = false
	resolution_text.unfocused()

func _on_audio_focus_exited() -> void:
	cursor_audio.visible = false
	audio_text.unfocused()

func _on_fullscreen_focus_exited() -> void:
	cursor_fullscreen.visible = false

func _on_up_jump_focus_exited() -> void:
	cursor_up_jump.visible = false

func _on_settings_back_focus_exited() -> void:
	if settings_back_text and settings_back_text.has_method("unfocused"):
		settings_back_text.unfocused()
	elif settings_back_text:
		settings_back_text.texture = preload("res://assets/UI/Buttons/back.png")

func _on_resolution_slider_changed(value: float) -> void:
	var index := int(value)
	if index < RESOLUTIONS.size():
		var size: Vector2i = RESOLUTIONS[index]
		DisplayServer.window_set_size(size)
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_fullscreen_toggled(button_pressed: bool) -> void:
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)

func _on_up_jump_toggled(button_pressed: bool) -> void:
	Globals.up_input_is_jump = button_pressed

func _clear_settings_highlight() -> void:
	cursor_resolution.visible = false
	cursor_audio.visible = false
	cursor_fullscreen.visible = false
	cursor_up_jump.visible = false
	if resolution_text:
		resolution_text.unfocused()
	if audio_text:
		audio_text.unfocused()
	if settings_back_text and settings_back_text.has_method("unfocused"):
		settings_back_text.unfocused()
	elif settings_back_text:
		settings_back_text.texture = preload("res://assets/UI/Buttons/back.png")
	if settings_back_arrow:
		settings_back_arrow.texture = preload("res://assets/UI/Buttons/back.png")

func _get_current_resolution_index() -> int:
	var current_size := DisplayServer.window_get_size()
	for i in range(RESOLUTIONS.size()):
		if RESOLUTIONS[i] == current_size:
			return i
	return 0

func _on_settings_back_pressed() -> void:
	_clear_settings_highlight()
	back_pressed.emit()