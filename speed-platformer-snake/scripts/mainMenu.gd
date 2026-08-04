extends Control

# reference to scenemanager, set when initialized
var scene_manager

# main menu texture
var main_screen: TextureRect
var game_title: TextureRect

# scene references
var main_menu: VBoxContainer
var game_modes: VBoxContainer

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
var cursor_settings_back: Control

# buttons
var normal_button: Button
var practice_button: Button
var two_player_button: Button
var settings_back_button: Button

# texts
var normal_text: TextureRect
var practice_text: TextureRect
var two_player_text: TextureRect

## Initialize the main menu panels and wire their controls.
func _ready() -> void:
	_cache_scene_references()
	_connect_main_menu_signals()
	_setup_initial_state()

# Link References to Different Scenes
func _cache_scene_references() -> void:
	main_screen = get_node("Main Screen")
	main_menu = get_node("Main")
	game_modes = get_node("GameModes")

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

# Link references to the game mode variables
func _connect_game_mode_signals() -> void:
	# references to cursors
	cursor_normal = get_node("GameModes/NormalMode/NormalCursor")
	cursor_practice = get_node("GameModes/PracticeMode/PracticeCursor")
	cursor_two_player = get_node("GameModes/2PlayerMode/2PlayerCursor")
	cursor_settings_back = get_node("GameModes/Back/BackCursor")

	# references to buttons
	normal_button = get_node("GameModes/NormalMode/normal")
	practice_button = get_node("GameModes/PracticeMode/practice")
	two_player_button = get_node("GameModes/2PlayerMode/2player")
	settings_back_button = get_node("GameModes/Back/back")

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
	settings_back_button.focus_entered.connect(_on_back_focus_entered)
	settings_back_button.focus_exited.connect(_on_back_focus_exited)
	settings_back_button.pressed.connect(_on_back_pressed)

func _set_main_menu_visible(visible: bool) -> void:
	main_menu.visible = visible
	game_title.visible = visible

func _set_game_modes_visible(visible: bool) -> void:
	game_modes.visible = visible
	main_menu.visible = not visible
	game_title.visible = not visible

func _hide_all_cursors() -> void:
	cursor_start.visible = false
	cursor_htp.visible = false
	cursor_quit.visible = false
	cursor_settings.visible = false
	cursor_normal.visible = false
	cursor_practice.visible = false
	cursor_two_player.visible = false
	cursor_settings_back.visible = false

# Set Visibilities of the cursors
func _setup_initial_state() -> void:
	# Set the vboxcontainers visibility
	_set_main_menu_visible(true)
	game_modes.visible = false

	# Main Menu
	_hide_all_cursors()
	start_button.grab_focus()
	cursor_start.visible = true

	# Game Modes
	cursor_normal.visible = false
	cursor_practice.visible = false
	cursor_two_player.visible = false
	cursor_settings_back.visible = false

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
	scene_manager.how_to_play()

func _on_howtoplay_game_focus_exited() -> void:
	cursor_htp.visible = false
	htp_text.unfocused()

func _on_howtoplay_game_focus_entered() -> void:
	cursor_htp.visible = true
	htp_text.focused()

## Goes to Settings
func _on_settings_pressed() -> void:
	scene_manager.settings()

func _on_settings_focus_exited() -> void:
	cursor_settings.visible = false
	settings_text.unfocused()

func _on_settings_focus_entered() -> void:
	cursor_settings.visible = true
	settings_text.focused()

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
	cursor_settings_back.visible = true

func _on_back_focus_exited() -> void:
	cursor_settings_back.visible = false
