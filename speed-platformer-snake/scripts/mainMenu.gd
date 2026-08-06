extends Control

# reference to scenemanager, set when initialized
var scene_manager

# main menu texture
var main_screen: TextureRect
var game_title: TextureRect

# scene references
var main_menu: VBoxContainer
var game_modes: VBoxContainer
var how_to_play_menu: VBoxContainer
var settings_menu: VBoxContainer
var keybind_menu: VBoxContainer

## MAIN MENU

# cursor images
var cursor_start: Control
var cursor_htp: Control
var cursor_quit: Control
var cursor_settings: Control

# buttons
var start_button: Button
var howtoplay_button: Button
var quit_button: Button
var settings_button: Button

# texts
var start_text: TextureRect
var htp_text: TextureRect
var quit_text: TextureRect
var settings_text: TextureRect

## GAME MODES
# cursor images
var cursor_normal: Control
var cursor_practice: Control
var cursor_two_player: Control
var cursor_game_back: Control

# buttons
var normal_button: Button
var practice_button: Button
var two_player_button: Button
var game_back_button: Button

# texts
var normal_text: TextureRect
var practice_text: TextureRect
var two_player_text: TextureRect

## HOW TO PLAY
# buttons
var tutorial_button: Button
var how_to_play_back_button: Button

# cursor images
var tutorial_cursor: Control
var how_to_play_back_cursor: Control

# texts
var tutorial_text: TextureRect
var how_to_play_back_text: TextureRect
var basics_header: Label
var basics_body: Label

## SETTINGS
# controls
var volume_decrease_button: Button
var volume_increase_button: Button
var fullscreen_check: CheckBox
var keybind_button: Button
var settings_back_button: Button

# cursor images
var cursor_audio: Control
var cursor_fullscreen: Control
var cursor_keybind: Control
var cursor_settings_back_menu: Control

# texts
var audio_text: TextureRect
var volume_value_text: TextureRect
var fullscreen_text: TextureRect
var keybind_text: TextureRect
var settings_back_text: TextureRect

const VOLUME_STEP_DB := 5.0

## Initialize the main menu panels and wire their controls.
func _ready() -> void:
	_cache_scene_references()
	_connect_main_menu_signals()
	_connect_how_to_play_signals()
	_connect_settings_signals()
	_setup_initial_state()

# Link References to Different Scenes
func _cache_scene_references() -> void:
	main_screen = get_node("Main Screen")
	main_menu = get_node("Main")
	game_modes = get_node("GameModes")
	how_to_play_menu = get_node("HowToPlay")
	settings_menu = get_node("Settings")
	keybind_menu = get_node("Keybind")

# Link references to the variables
func _connect_main_menu_signals() -> void:
	# title
	game_title = get_node("Main/Game Title")

	# references to cursors
	cursor_start = get_node("Main/StartNode/StartCursor")
	cursor_htp = get_node("Main/HTPNode/HTPCursor")
	cursor_quit = get_node("Main/QuitNode/QuitCursor")
	cursor_settings = get_node("Main/SettingsNode/SettingsCursor")

	# references to buttons
	start_button = get_node("Main/StartNode/start game")
	howtoplay_button = get_node("Main/HTPNode/howtoplay game")
	quit_button = get_node("Main/QuitNode/quit game")
	settings_button = get_node("Main/SettingsNode/settings")
	
	# references to text
	start_text = get_node("Main/StartNode/StartText")
	htp_text = get_node("Main/HTPNode/HowToPlayText")
	quit_text = get_node("Main/QuitNode/QuitText")
	settings_text = get_node("Main/SettingsNode/SettingsText")
	
	# references to start
	start_button.focus_entered.connect(_on_start_game_focus_entered)
	start_button.focus_exited.connect(_on_start_game_focus_exited)
	start_button.pressed.connect(_on_start_game_pressed)
	
	# references to howtoplay
	howtoplay_button.focus_entered.connect(_on_howtoplay_game_focus_entered)
	howtoplay_button.focus_exited.connect(_on_howtoplay_game_focus_exited)
	howtoplay_button.pressed.connect(_on_howtoplay_game_pressed)
	
	# references to quit
	quit_button.focus_entered.connect(_on_quit_game_focus_entered)
	quit_button.focus_exited.connect(_on_quit_game_focus_exited)
	quit_button.pressed.connect(_on_quit_game_pressed)
	
	# references to settings
	settings_button.focus_entered.connect(_on_settings_focus_entered)
	settings_button.focus_exited.connect(_on_settings_focus_exited)
	settings_button.pressed.connect(_on_settings_pressed)

	_connect_game_mode_signals()

func _connect_how_to_play_signals() -> void:
	# references to buttons
	tutorial_button = get_node("HowToPlay/TutorialPlayNode/tutorial")
	how_to_play_back_button = get_node("HowToPlay/BackNode/back")

	# references to cursors
	tutorial_cursor = get_node("HowToPlay/TutorialPlayNode/PlayCursor")
	how_to_play_back_cursor = get_node("HowToPlay/BackNode/BackCursor")

	# references to text
	tutorial_text = get_node("HowToPlay/TutorialPlayNode/PlayTutorialText")
	how_to_play_back_text = get_node("HowToPlay/BackNode/BackText")
	basics_header = get_node("THE BASICS header")
	basics_body = get_node("THE BASICS body")

	# signal hookups
	tutorial_button.focus_entered.connect(_on_tutorial_focus_entered)
	tutorial_button.focus_exited.connect(_on_tutorial_focus_exited)
	tutorial_button.pressed.connect(_on_tutorial_pressed)
	how_to_play_back_button.focus_entered.connect(_on_how_to_play_back_focus_entered)
	how_to_play_back_button.focus_exited.connect(_on_how_to_play_back_focus_exited)
	how_to_play_back_button.pressed.connect(_on_how_to_play_back_pressed)

func _connect_settings_signals() -> void:
	# references to controls
	volume_decrease_button = get_node("Settings/Audio/VolumeDown")
	volume_increase_button = get_node("Settings/Audio/VolumeUp")
	fullscreen_check = get_node("Settings/Fullscreen/FullScreenCheck")
	keybind_button = get_node("Settings/Keybinds/keybind")
	settings_back_button = get_node("Settings/BackNode/back")

	# references to cursors
	cursor_audio = get_node("Settings/Audio/AudioCursor")
	cursor_fullscreen = get_node("Settings/Fullscreen/FullScreenCursor")
	cursor_keybind = get_node("Settings/Keybinds/KeybindCursor")
	cursor_settings_back_menu = get_node("Settings/BackNode/BackCursor")

	# references to text
	audio_text = get_node("Settings/Audio/AudioText")
	volume_value_text = get_node("Settings/Audio/VolumeValue")
	fullscreen_text = get_node("Settings/Fullscreen/FullScreenCheckText")
	keybind_text = get_node("Settings/Keybinds/KeybindText")
	settings_back_text = get_node("Settings/BackNode/BackText")

	# audio control signals
	volume_decrease_button.focus_entered.connect(_on_audio_focus_entered)
	volume_decrease_button.focus_exited.connect(_on_audio_focus_exited)
	volume_decrease_button.pressed.connect(_on_volume_decrease_pressed)
	volume_increase_button.focus_entered.connect(_on_audio_focus_entered)
	volume_increase_button.focus_exited.connect(_on_audio_focus_exited)
	volume_increase_button.pressed.connect(_on_volume_increase_pressed)

	# fullscreen control signals
	fullscreen_check.focus_entered.connect(_on_fullscreen_focus_entered)
	fullscreen_check.focus_exited.connect(_on_fullscreen_focus_exited)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)

	# keybind control signals
	keybind_button.focus_entered.connect(_on_keybind_focus_entered)
	keybind_button.focus_exited.connect(_on_keybind_focus_exited)
	keybind_button.pressed.connect(_on_keybind_pressed)

	# back button signals
	settings_back_button.focus_entered.connect(_on_settings_back_menu_focus_entered)
	settings_back_button.focus_exited.connect(_on_settings_back_menu_focus_exited)
	settings_back_button.pressed.connect(_on_settings_back_pressed)

	_initialize_settings_controls()

func _initialize_settings_controls() -> void:
	if fullscreen_check:
		fullscreen_check.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

	_update_volume_text()

func _set_how_to_play_text_visible(visible: bool) -> void:
	basics_header.visible = visible
	basics_body.visible = visible

# Link references to the game mode variables
func _connect_game_mode_signals() -> void:
	# references to cursors
	cursor_normal = get_node("GameModes/NormalMode/NormalCursor")
	cursor_practice = get_node("GameModes/PracticeMode/PracticeCursor")
	cursor_two_player = get_node("GameModes/2PlayerMode/2PlayerCursor")
	cursor_game_back = get_node("GameModes/Back/BackCursor")

	# references to buttons
	normal_button = get_node("GameModes/NormalMode/normal")
	practice_button = get_node("GameModes/PracticeMode/practice")
	two_player_button = get_node("GameModes/2PlayerMode/2player")
	game_back_button = get_node("GameModes/Back/back")

	# references to text
	normal_text = get_node("GameModes/NormalMode/NormalText")
	practice_text = get_node("GameModes/PracticeMode/PracticeText")
	two_player_text = get_node("GameModes/2PlayerMode/2PlayerText")

	# references to normal
	normal_button.focus_entered.connect(_on_normal_focus_entered)
	normal_button.focus_exited.connect(_on_normal_focus_exited)
	normal_button.pressed.connect(_on_normal_pressed)

	# references to practice
	practice_button.focus_entered.connect(_on_practice_focus_entered)
	practice_button.focus_exited.connect(_on_practice_focus_exited)
	practice_button.pressed.connect(_on_practice_pressed)

	# references to two player
	two_player_button.focus_entered.connect(_on_two_player_focus_entered)
	two_player_button.focus_exited.connect(_on_two_player_focus_exited)
	two_player_button.pressed.connect(_on_two_player_pressed)

	# references to back
	game_back_button.focus_entered.connect(_on_back_focus_entered)
	game_back_button.focus_exited.connect(_on_back_focus_exited)
	game_back_button.pressed.connect(_on_back_pressed)

func _set_main_menu_visible(visible: bool) -> void:
	main_menu.visible = visible
	game_title.visible = visible
	settings_menu.visible = false
	keybind_menu.visible = false
	_set_how_to_play_text_visible(false)

func _set_game_modes_visible(visible: bool) -> void:
	game_modes.visible = visible
	main_menu.visible = not visible
	game_title.visible = not visible
	how_to_play_menu.visible = false
	settings_menu.visible = false
	keybind_menu.visible = false
	_set_how_to_play_text_visible(false)

func _set_how_to_play_visible(visible: bool) -> void:
	how_to_play_menu.visible = visible
	main_menu.visible = not visible
	game_modes.visible = false
	game_title.visible = not visible
	settings_menu.visible = false
	keybind_menu.visible = false
	_set_how_to_play_text_visible(visible)

func _set_settings_visible(visible: bool) -> void:
	settings_menu.visible = visible
	main_menu.visible = not visible
	game_modes.visible = false
	how_to_play_menu.visible = false
	keybind_menu.visible = false
	game_title.visible = not visible
	_set_how_to_play_text_visible(false)

func _set_keybind_visible(visible: bool) -> void:
	keybind_menu.visible = visible
	settings_menu.visible = not visible
	main_menu.visible = false
	game_modes.visible = false
	how_to_play_menu.visible = false
	game_title.visible = false
	_set_how_to_play_text_visible(false)

func _hide_all_cursors() -> void:
	cursor_start.visible = false
	cursor_htp.visible = false
	cursor_quit.visible = false
	cursor_settings.visible = false
	cursor_normal.visible = false
	cursor_practice.visible = false
	cursor_two_player.visible = false
	cursor_game_back.visible = false
	tutorial_cursor.visible = false
	how_to_play_back_cursor.visible = false
	cursor_audio.visible = false
	cursor_fullscreen.visible = false
	cursor_keybind.visible = false
	cursor_settings_back_menu.visible = false

# Set Visibilities of the cursors
func _setup_initial_state() -> void:
	# Set the vboxcontainers visibility
	_set_main_menu_visible(true)
	game_modes.visible = false
	how_to_play_menu.visible = false
	settings_menu.visible = false
	keybind_menu.visible = false
	_set_how_to_play_text_visible(false)

	# Main Menu
	_hide_all_cursors()
	start_button.grab_focus()
	cursor_start.visible = true

	# Game Modes
	cursor_normal.visible = false
	cursor_practice.visible = false
	cursor_two_player.visible = false
	cursor_game_back.visible = false

## Opens the game modes panel when pressed
func _on_start_game_pressed() -> void:
	_set_game_modes_visible(true)
	_hide_all_cursors()
	cursor_normal.visible = true
	normal_text.focused()
	normal_button.grab_focus()

func _on_start_game_focus_entered() -> void:
	cursor_start.visible = true
	start_text.focused()

func _on_start_game_focus_exited() -> void:
	cursor_start.visible = false
	start_text.unfocused()

## Goes to the How to play section inside of main menu scene through panel switching.
func _on_howtoplay_game_pressed() -> void:
	_set_how_to_play_visible(true)
	_hide_all_cursors()
	how_to_play_back_button.grab_focus()
	how_to_play_back_cursor.visible = true

func _on_howtoplay_game_focus_exited() -> void:
	cursor_htp.visible = false
	htp_text.unfocused()

func _on_howtoplay_game_focus_entered() -> void:
	cursor_htp.visible = true
	htp_text.focused()

## Goes to Settings
func _on_settings_pressed() -> void:
	_set_settings_visible(true)
	_hide_all_cursors()
	volume_decrease_button.grab_focus()
	cursor_audio.visible = true
	audio_text.focused()

func _on_settings_focus_exited() -> void:
	cursor_settings.visible = false
	settings_text.unfocused()

func _on_settings_focus_entered() -> void:
	cursor_settings.visible = true
	settings_text.focused()

func _on_audio_focus_entered() -> void:
	cursor_audio.visible = true
	audio_text.focused()

func _on_audio_focus_exited() -> void:
	cursor_audio.visible = false
	audio_text.unfocused()

func _on_fullscreen_focus_entered() -> void:
	cursor_fullscreen.visible = true
	fullscreen_text.focused()

func _on_fullscreen_focus_exited() -> void:
	cursor_fullscreen.visible = false
	fullscreen_text.unfocused()

func _on_keybind_focus_entered() -> void:
	cursor_keybind.visible = true
	keybind_text.focused()

func _on_keybind_focus_exited() -> void:
	cursor_keybind.visible = false
	keybind_text.unfocused()

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
	_set_keybind_visible(true)

func _on_settings_back_menu_focus_entered() -> void:
	cursor_settings_back_menu.visible = true
	settings_back_text.focused()

func _on_settings_back_menu_focus_exited() -> void:
	cursor_settings_back_menu.visible = false
	settings_back_text.unfocused()

func _on_settings_back_pressed() -> void:
	_set_settings_visible(false)
	_hide_all_cursors()
	start_button.grab_focus()

## Stops the game when pressed
func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_quit_game_focus_entered() -> void:
	cursor_quit.visible = true
	quit_text.focused()

func _on_quit_game_focus_exited() -> void:
	cursor_quit.visible = false
	quit_text.unfocused()

## GAME MODES

## Starts normal mode when pressed
func _on_normal_pressed() -> void:
	scene_manager.normal_mode()

func _on_normal_focus_entered() -> void:
	cursor_normal.visible = true
	normal_text.focused()

func _on_normal_focus_exited() -> void:
	cursor_normal.visible = false
	normal_text.unfocused()

## Starts practice mode when pressed
func _on_practice_pressed() -> void:
	scene_manager.practice_mode()

func _on_practice_focus_entered() -> void:
	cursor_practice.visible = true
	practice_text.focused()

func _on_practice_focus_exited() -> void:
	cursor_practice.visible = false
	practice_text.unfocused()

## Starts two player mode when pressed
func _on_two_player_pressed() -> void:
	scene_manager.two_player_mode()

func _on_two_player_focus_entered() -> void:
	cursor_two_player.visible = true
	two_player_text.focused()

func _on_two_player_focus_exited() -> void:
	cursor_two_player.visible = false
	two_player_text.unfocused()

## Returns to the main menu when pressed
func _on_back_pressed() -> void:
	_set_game_modes_visible(false)
	_hide_all_cursors()
	start_button.grab_focus()

func _on_back_focus_entered() -> void:
	cursor_game_back.visible = true

func _on_back_focus_exited() -> void:
	cursor_game_back.visible = false

## HOW TO PLAY
func _on_tutorial_pressed() -> void:
	scene_manager.start_tutorial()

func _on_tutorial_focus_entered() -> void:
	tutorial_cursor.visible = true
	tutorial_text.focused()

func _on_tutorial_focus_exited() -> void:
	tutorial_cursor.visible = false
	tutorial_text.unfocused()

func _on_how_to_play_back_pressed() -> void:
	_set_how_to_play_visible(false)
	_hide_all_cursors()
	start_button.grab_focus()

func _on_how_to_play_back_focus_entered() -> void:
	how_to_play_back_cursor.visible = true
	how_to_play_back_text.focused()

func _on_how_to_play_back_focus_exited() -> void:
	how_to_play_back_cursor.visible = false
	how_to_play_back_text.unfocused()

func _unhandled_input(event: InputEvent) -> void:
	if keybind_menu.visible and event.is_action_pressed("ui_cancel"):
		_set_keybind_visible(false)
		game_back_button.grab_focus()
		get_viewport().set_input_as_handled()
		return
