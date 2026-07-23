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

# refernces to the buttons
@onready var start_button := $"MainMenuTitle/VBoxContainer/StartNode/start game"
@onready var howtoplay_button := $"MainMenuTitle/VBoxContainer/HTPNode/howtoplay game"
@onready var quit_button := $"MainMenuTitle/VBoxContainer/QuitNode/quit game"
@onready var back_button := $HowToPlay/BackNode/back
@onready var settings_button := $MainMenuTitle/VBoxContainer/SettingsNode/settings

# references to texts
@onready var start_text := $"MainMenuTitle/VBoxContainer/StartNode/StartText"
@onready var htp_text := $"MainMenuTitle/VBoxContainer/HTPNode/HowToPlayText"
@onready var quit_text := $"MainMenuTitle/VBoxContainer/QuitNode/QuitText"
@onready var settings_text := $MainMenuTitle/VBoxContainer/SettingsNode/SettingsText

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
	settings_button.grab_focus()

func _on_settings_focus_exited() -> void:
	cursor_settings.visible = false
	settings_text.unfocused()

func _on_settings_focus_entered() -> void:
	cursor_settings.visible = true
	settings_text.focused()

func _on_volume_slider_changed(value: float) -> void:
	AudioManager.set_bus_volume_db(AudioManager.MUSIC_BUS, value)

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
	settings_button.grab_focus()
	mainmenu.visible = true
	howtoplay.visible = false
	settings.visible = false
