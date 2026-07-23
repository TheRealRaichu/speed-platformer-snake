extends Control

## MAIN MENU
# reference to scenemanger, set when initialized
var scene_manager
# reference to the 2 nodes.
@onready var howtoplay := $HowToPlay
@onready var mainmenu := $MainMenuTitle
@onready var settings := $Settings

# references to the cursor images
@onready var cursor_start := $MainMenuTitle/VBoxContainer/StartNode/StartCursor
@onready var cursor_htp := $MainMenuTitle/VBoxContainer/HTPNode/HTPCursor
@onready var cursor_quit := $MainMenuTitle/VBoxContainer/QuitNode/QuitCursor
@onready var cursor_settings := $MainMenuTitle/VBoxContainer/SettingsNode/SettingsCursor

@onready var volume_slider := $Settings/Audio/AudioControl
@onready var resolution_slider := $Settings/Resolution/ResolutionControl
@onready var fullscreen_check := $Settings/Fullscreen/FullScreenCheck
@onready var up_jump_check := $Settings/UpInputJump/JumpCheck
@onready var cursor_resolution := $Settings/Resolution/ResolutionControl/ResolutionCursor
@onready var cursor_audio := $Settings/Audio/AudioControl/AudioCursor
@onready var cursor_fullscreen := $Settings/Fullscreen/FullScreenCursor
@onready var cursor_up_jump := $Settings/UpInputJump/JumpCursor
@onready var cursor_settings_back := $Settings/BackNode/SettingsBackCursor

# refernces to the buttons
@onready var start_button := $"MainMenuTitle/VBoxContainer/StartNode/start game"
@onready var howtoplay_button := $"MainMenuTitle/VBoxContainer/HTPNode/howtoplay game"
@onready var quit_button := $"MainMenuTitle/VBoxContainer/QuitNode/quit game"
@onready var back_button := $HowToPlay/BackNode/back
@onready var settings_button := $MainMenuTitle/VBoxContainer/SettingsNode/settings
@onready var settings_back_button := $Settings/BackNode/back

# references to texts
@onready var start_text := $"MainMenuTitle/VBoxContainer/StartNode/StartText"
@onready var htp_text := $"MainMenuTitle/VBoxContainer/HTPNode/HowToPlayText"
@onready var quit_text := $"MainMenuTitle/VBoxContainer/QuitNode/QuitText"
@onready var settings_text := $MainMenuTitle/VBoxContainer/SettingsNode/SettingsText
@onready var resolution_text := $Settings/Resolution/ResolutionControl/ResolutionText
@onready var audio_text := $Settings/Audio/AudioControl/AudioText
@onready var fullscreen_text := $Settings/Fullscreen/FullScreenCheck
@onready var up_jump_text := $Settings/UpInputJump/JumpCheck
@onready var settings_back_text := $Settings/BackNode/BackText
@onready var settings_back_arrow := $Settings/BackNode/TextureRect

const RESOLUTIONS := [Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440)]

## Initialize the main menu as true and How To Play section as false when first time running, and initilizaed cursor as false.
func _ready() -> void:
	start_button.grab_focus() # start button takes focus for key navigation as the first

	mainmenu.visible = true
	howtoplay.visible = false
	settings.visible = false
	cursor_start.visible = true
	cursor_htp.visible = false
	cursor_quit.visible = false
	cursor_settings.visible = false
	cursor_resolution.visible = false
	cursor_audio.visible = false
	cursor_fullscreen.visible = false
	cursor_up_jump.visible = false
	cursor_settings_back.visible = false

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

## Starts the game when pressed
func _on_start_game_pressed() -> void:
	scene_manager.start_game()

func _on_start_game_focus_entered() -> void:
	cursor_start.visible = true
	start_text.focused()

func _on_start_game_focus_exited() -> void:
	cursor_start.visible = false
	start_text.unfocused()
	

## Goes to the How to play section inside of main menu scene through turn on and off nodes.
func _on_howtoplay_game_pressed() -> void:
	mainmenu.visible = false
	howtoplay.visible = true
	back_button.grab_focus() # Sets cursor to back button

func _on_howtoplay_game_focus_exited() -> void:
	cursor_htp.visible = false
	htp_text.unfocused()

func _on_howtoplay_game_focus_entered() -> void:
	cursor_htp.visible = true
	htp_text.focused()

## Goes to Settings
func _on_settings_pressed() -> void:
	mainmenu.visible = false
	settings.visible = true
	settings_back_button.grab_focus() # Sets cursor to back button

func _on_settings_focus_exited() -> void:
	cursor_settings.visible = false
	settings_text.unfocused()

func _on_settings_focus_entered() -> void:
	cursor_settings.visible = true
	settings_text.focused()

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
	cursor_settings_back.visible = true
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
	cursor_settings_back.visible = false
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
	cursor_settings_back.visible = false
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

## Stops the game when pressed
func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_quit_game_focus_entered() -> void:
	cursor_quit.visible = true
	quit_text.focused()

func _on_quit_game_focus_exited() -> void:
	cursor_quit.visible = false
	quit_text.unfocused()


## Go back to main menu
func _on_back_pressed() -> void:
	howtoplay_button.grab_focus()
	mainmenu.visible = true
	howtoplay.visible = false
	settings.visible = false

func _on_settings_back_pressed() -> void:
	_clear_settings_highlight()
	mainmenu.visible = true
	howtoplay.visible = false
	settings.visible = false
	settings_button.grab_focus()
