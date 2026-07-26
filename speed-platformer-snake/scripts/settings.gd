extends Control

## SETTINGS
signal back_pressed
signal keybind_pressed

# controls
var volume_slider: HSlider
var resolution_slider: HSlider
var fullscreen_check: CheckButton
var up_jump_check: CheckButton
var keybind_control: Button
var settings_back_button: Button

# cursors
var cursor_resolution: Control
var cursor_audio: Control
var cursor_fullscreen: Control
var cursor_up_jump: Control
var cursor_keybind: Control

# text
var resolution_text: TextureRect
var audio_text: TextureRect
var settings_back_text: TextureRect

const RESOLUTIONS := [Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440)]

func _ready() -> void:
	_connect_controls()
	_initialize_settings_controls()

func _connect_controls() -> void:
	# references to the buttons, sliders, or checks
	volume_slider = get_node("Settings/Audio/AudioControl")
	resolution_slider = get_node("Settings/Resolution/ResolutionControl")
	fullscreen_check = get_node("Settings/Fullscreen/FullScreenCheck")
	up_jump_check = get_node("Settings/UpInputJump/JumpCheck")
	keybind_control = get_node("Settings/Keybinds/keybind")
	settings_back_button = get_node("Settings/BackNode/back")

	# references to cursors
	cursor_resolution = get_node("Settings/Resolution/ResolutionControl/ResolutionCursor")
	cursor_audio = get_node("Settings/Audio/AudioControl/AudioCursor")
	cursor_fullscreen = get_node("Settings/Fullscreen/FullScreenCursor")
	cursor_up_jump = get_node("Settings/UpInputJump/JumpCursor")
	cursor_keybind = get_node("Settings/Keybinds/KeybindCursor")

	# references to text
	resolution_text = get_node("Settings/Resolution/ResolutionControl/ResolutionText")
	audio_text = get_node("Settings/Audio/AudioControl/AudioText")
	settings_back_text = get_node("Settings/BackNode/BackText")

	# Set cursor visibility
	cursor_audio.visible = false
	cursor_resolution.visible = false
	cursor_fullscreen.visible = false
	cursor_up_jump.visible = false
	cursor_keybind.visible = false
	
	# audio slider signals
	volume_slider.focus_entered.connect(_on_audio_focus_entered)
	volume_slider.focus_exited.connect(_on_audio_focus_exited)
	volume_slider.value_changed.connect(_on_audio_value_changed)
	
	# resolution slider signals
	resolution_slider.focus_entered.connect(_on_resolution_focus_entered)
	resolution_slider.focus_exited.connect(_on_resolution_focus_exited)
	
	# fullscreen check signals
	fullscreen_check.focus_entered.connect(_on_fullscreen_focus_entered)
	fullscreen_check.focus_exited.connect(_on_fullscreen_focus_exited)
	
	# up jump check signals
	up_jump_check.focus_entered.connect(_on_up_jump_focus_entered)
	up_jump_check.focus_exited.connect(_on_up_jump_focus_exited)
	
	# keybind control signals
	keybind_control.focus_entered.connect(_on_keybind_focus_entered)
	keybind_control.focus_exited.connect(_on_keybind_focus_exited)
	keybind_control.pressed.connect(_on_keybind_pressed)
	
	# back button signals
	settings_back_button.focus_entered.connect(_on_settings_back_focus_entered)
	settings_back_button.focus_exited.connect(_on_settings_back_focus_exited)
	settings_back_button.pressed.connect(_on_settings_back_pressed)

func _initialize_settings_controls() -> void:
	# Initialize control values WITHOUT triggering signal handlers
	if volume_slider:
		volume_slider.min_value = AudioManager.MIN_VOLUME
		volume_slider.max_value = AudioManager.MAX_VOLUME
		volume_slider.step = 1.0
		volume_slider.value = AudioManager.get_bus_volume_db(AudioManager.MUSIC_BUS)

	if resolution_slider:
		resolution_slider.min_value = 0
		resolution_slider.max_value = RESOLUTIONS.size() - 1
		resolution_slider.step = 1.0
		resolution_slider.value = _get_current_resolution_index()

	if fullscreen_check:
		fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

	if up_jump_check:
		up_jump_check.button_pressed = Globals.up_input_is_jump

## Called by the main menu script right after this panel is shown.
func focus_first_control() -> void:
	volume_slider.grab_focus()

## Called by main menu script after returning from keybind panel.
func focus_keybind_control() -> void:
	keybind_control.grab_focus()

func _on_audio_focus_entered() -> void:
	cursor_audio.visible = true

func _on_audio_focus_exited() -> void:
	cursor_audio.visible = false

func _on_resolution_focus_entered() -> void:
	cursor_resolution.visible = true

func _on_resolution_focus_exited() -> void:
	cursor_resolution.visible = false

func _on_fullscreen_focus_entered() -> void:
	cursor_fullscreen.visible = true

func _on_fullscreen_focus_exited() -> void:
	cursor_fullscreen.visible = false

func _on_up_jump_focus_entered() -> void:
	cursor_up_jump.visible = true

func _on_up_jump_focus_exited() -> void:
	cursor_up_jump.visible = false

func _on_keybind_focus_entered() -> void:
	cursor_keybind.visible = true

func _on_keybind_focus_exited() -> void:
	cursor_keybind.visible = false

func _on_audio_value_changed(value: float) -> void:
	AudioManager.set_bus_volume_db(AudioManager.MUSIC_BUS, value)

func _on_keybind_pressed() -> void:
	keybind_pressed.emit()

func _on_settings_back_focus_entered() -> void:
	pass

func _on_settings_back_focus_exited() -> void:
	pass

func _on_settings_back_pressed() -> void:
	back_pressed.emit()

func _get_current_resolution_index() -> int:
	var current_size := DisplayServer.window_get_size()
	for i in range(RESOLUTIONS.size()):
		if RESOLUTIONS[i] == current_size:
			return i
	return 0