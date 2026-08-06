extends Control

## SETTINGS
var scene_manager

# controls
var volume_decrease_button: Button
var volume_increase_button: Button
var fullscreen_check: CheckBox
var keybind_control: Button
var settings_back_button: Button

# cursors
var cursor_audio: Control
var cursor_fullscreen: Control
var cursor_keybind: Control

# text
var audio_text: TextureRect
var volume_value_text: TextureRect
var fullscreen_text: TextureRect
var keybind_text: TextureRect
var settings_back_text: TextureRect

const VOLUME_STEP_DB := 5.0

func _ready() -> void:
	_connect_controls()
	_initialize_settings_controls()
	volume_decrease_button.grab_focus()

func _connect_controls() -> void:
	# references to the buttons, sliders, or checks
	volume_decrease_button = get_node("Settings/Audio/AudioControl/VolumeDown")
	volume_increase_button = get_node("Settings/Audio/AudioControl/VolumeUp")
	fullscreen_check = get_node("Settings/Fullscreen/FullScreenCheck")
	keybind_control = get_node("Settings/Keybinds/keybind")
	settings_back_button = get_node("Settings/BackNode/back")

	# references to cursors
	cursor_audio = get_node("Settings/Audio/AudioControl/AudioCursor")
	cursor_fullscreen = get_node("Settings/Fullscreen/FullScreenCursor")
	cursor_keybind = get_node("Settings/Keybinds/KeybindCursor")

	# references to text
	audio_text = get_node("Settings/Audio/AudioControl/AudioText")
	volume_value_text = get_node("Settings/Audio/AudioControl/VolumeValue")
	fullscreen_text = get_node("Settings/Fullscreen/FullScreenCheckText")
	keybind_text = get_node("Settings/Keybinds/KeybindText")
	settings_back_text = get_node("Settings/BackNode/BackText")

	# Set cursor visibility
	cursor_audio.visible = false
	cursor_fullscreen.visible = false
	cursor_keybind.visible = false
	
	# audio volume button signals
	volume_decrease_button.focus_entered.connect(_on_audio_focus_entered)
	volume_decrease_button.focus_exited.connect(_on_audio_focus_exited)
	volume_decrease_button.pressed.connect(_on_volume_decrease_pressed)
	volume_increase_button.focus_entered.connect(_on_audio_focus_entered)
	volume_increase_button.focus_exited.connect(_on_audio_focus_exited)
	volume_increase_button.pressed.connect(_on_volume_increase_pressed)
	
	# fullscreen check signals
	fullscreen_check.focus_entered.connect(_on_fullscreen_focus_entered)
	fullscreen_check.focus_exited.connect(_on_fullscreen_focus_exited)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	
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
	_update_volume_text()

	if fullscreen_check:
		fullscreen_check.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_audio_focus_entered() -> void:
	cursor_audio.visible = true

func _on_audio_focus_exited() -> void:
	cursor_audio.visible = false

func _on_fullscreen_focus_entered() -> void:
	cursor_fullscreen.visible = true

func _on_fullscreen_focus_exited() -> void:
	cursor_fullscreen.visible = false

func _on_keybind_focus_entered() -> void:
	cursor_keybind.visible = true

func _on_keybind_focus_exited() -> void:
	cursor_keybind.visible = false

func _on_volume_decrease_pressed() -> void:
	_adjust_music_volume(-VOLUME_STEP_DB)

func _on_volume_increase_pressed() -> void:
	_adjust_music_volume(VOLUME_STEP_DB)

func _adjust_music_volume(delta_db: float) -> void:
	var current_volume := AudioManager.get_bus_volume_db(AudioManager.MUSIC_BUS)
	AudioManager.set_bus_volume_db(AudioManager.MUSIC_BUS, current_volume + delta_db)
	_update_volume_text()

func _update_volume_text() -> void:
	if volume_value_text:
		volume_value_text.visible = true

func _on_fullscreen_toggled(pressed: bool) -> void:
	var target_mode := DisplayServer.WINDOW_MODE_FULLSCREEN if pressed else DisplayServer.WINDOW_MODE_WINDOWED
	if DisplayServer.window_get_mode() != target_mode:
		DisplayServer.window_set_mode(target_mode)

func _on_keybind_pressed() -> void:
	scene_manager.keybind()

func _on_settings_back_focus_entered() -> void:
	pass

func _on_settings_back_focus_exited() -> void:
	pass

func _on_settings_back_pressed() -> void:
	scene_manager.main_menu()
