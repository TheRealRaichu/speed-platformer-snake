extends Control
 
## MAIN MENU
# reference to scenemanager, set when initialized
var scene_manager
 
# references to the scenes to switch
const MAIN_MENU_SCENE := preload("res://scenes/main_menu_panel.tscn")
const HOW_TO_PLAY_SCENE := preload("res://scenes/how_to_play.tscn")
const SETTINGS_SCENE := preload("res://scenes/settings.tscn")
 
# references to the scenes
var main_menu_panel: Control
var how_to_play_panel: Control
var settings_panel: Control
 
# references to the cursor images
var cursor_start: Control
var cursor_htp: Control
var cursor_quit: Control
var cursor_settings: Control
 
# references to the buttons
var start_button: Button
var howtoplay_button: Button
var quit_button: Button
var settings_button: Button
 
# references to texts
var start_text: TextureRect
var htp_text: TextureRect
var quit_text: TextureRect
var settings_text: TextureRect
 
## Initialize the main menu panels and wire their controls.
func _ready() -> void:
	_instantiate_panels()
	_connect_panel_signals()
	_setup_initial_state()
 
func _instantiate_panels() -> void:
	main_menu_panel = MAIN_MENU_SCENE.instantiate()
	main_menu_panel.name = "MainMenuPanel"
	add_child(main_menu_panel)
	main_menu_panel.owner = self
 
	how_to_play_panel = HOW_TO_PLAY_SCENE.instantiate()
	how_to_play_panel.name = "HowToPlayPanel"
	add_child(how_to_play_panel)
	how_to_play_panel.owner = self
	how_to_play_panel.visible = false
 
	settings_panel = SETTINGS_SCENE.instantiate()
	settings_panel.name = "SettingsPanel"
	add_child(settings_panel)
	settings_panel.owner = self
	settings_panel.visible = false

func _connect_panel_signals() -> void:
	cursor_start = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/StartNode/StartCursor")
	cursor_htp = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/HTPNode/HTPCursor")
	cursor_quit = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/QuitNode/QuitCursor")
	cursor_settings = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/SettingsNode/SettingsCursor")
 
	start_button = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/StartNode/start game")
	howtoplay_button = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/HTPNode/howtoplay game")
	quit_button = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/QuitNode/quit game")
	settings_button = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/SettingsNode/settings")
 
	start_text = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/StartNode/StartText")
	htp_text = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/HTPNode/HowToPlayText")
	quit_text = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/QuitNode/QuitText")
	settings_text = main_menu_panel.get_node("MainMenuTitle/VBoxContainer/SettingsNode/SettingsText")
 
	start_button.focus_entered.connect(_on_start_game_focus_entered)
	start_button.focus_exited.connect(_on_start_game_focus_exited)
	start_button.pressed.connect(_on_start_game_pressed)
 
	howtoplay_button.focus_entered.connect(_on_howtoplay_game_focus_entered)
	howtoplay_button.focus_exited.connect(_on_howtoplay_game_focus_exited)
	howtoplay_button.pressed.connect(_on_howtoplay_game_pressed)
 
	quit_button.focus_entered.connect(_on_quit_game_focus_entered)
	quit_button.focus_exited.connect(_on_quit_game_focus_exited)
	quit_button.pressed.connect(_on_quit_game_pressed)
 
	settings_button.focus_entered.connect(_on_settings_focus_entered)
	settings_button.focus_exited.connect(_on_settings_focus_exited)
	settings_button.pressed.connect(_on_settings_pressed)
 
	# Panels notify us when their own "back" button is pressed.
	how_to_play_panel.back_pressed.connect(_on_how_to_play_back_pressed)
	settings_panel.back_pressed.connect(_on_settings_back_pressed)
 
func _setup_initial_state() -> void:
	var legacy_main_screen := get_node_or_null("Main Screen")
	var legacy_menu_title := get_node_or_null("MainMenuTitle")
	var legacy_how_to_play := get_node_or_null("HowToPlay")
	var legacy_settings := get_node_or_null("Settings")
	if legacy_main_screen:
		legacy_main_screen.visible = true
	if legacy_menu_title:
		legacy_menu_title.visible = false
	if legacy_how_to_play:
		legacy_how_to_play.visible = false
	if legacy_settings:
		legacy_settings.visible = false
 
	start_button.grab_focus()
	main_menu_panel.visible = true
	how_to_play_panel.visible = false
	settings_panel.visible = false
	cursor_start.visible = true
	cursor_htp.visible = false
	cursor_quit.visible = false
	cursor_settings.visible = false
 
## Starts the game when pressed
func _on_start_game_pressed() -> void:
	scene_manager.start_game()
 
func _on_start_game_focus_entered() -> void:
	cursor_start.visible = true
	start_text.focused()
 
func _on_start_game_focus_exited() -> void:
	cursor_start.visible = false
	start_text.unfocused()
 
## Goes to the How to play section inside of main menu scene through panel switching.
func _on_howtoplay_game_pressed() -> void:
	main_menu_panel.visible = false
	how_to_play_panel.visible = true
	settings_panel.visible = false
	how_to_play_panel.focus_back_button()
 
func _on_howtoplay_game_focus_exited() -> void:
	cursor_htp.visible = false
	htp_text.unfocused()
 
func _on_howtoplay_game_focus_entered() -> void:
	cursor_htp.visible = true
	htp_text.focused()
 
## Goes to Settings
func _on_settings_pressed() -> void:
	main_menu_panel.visible = false
	how_to_play_panel.visible = false
	settings_panel.visible = true
	settings_panel.focus_back_button()
 
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
 
## Go back to main menu (From the How To Play)
func _on_how_to_play_back_pressed() -> void:
	howtoplay_button.grab_focus()
	main_menu_panel.visible = true
	how_to_play_panel.visible = false
	settings_panel.visible = false
 
## Go back to main menu (From the Settings)
func _on_settings_back_pressed() -> void:
	main_menu_panel.visible = true
	how_to_play_panel.visible = false
	settings_panel.visible = false
	settings_button.grab_focus()
