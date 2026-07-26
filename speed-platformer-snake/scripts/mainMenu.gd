extends Control
 
## MAIN MENU
# reference to scenemanager, set when initialized
var scene_manager
 
# references to the scenes to switch
const HOW_TO_PLAY_SCENE := preload("res://scenes/how_to_play.tscn")
const SETTINGS_SCENE := preload("res://scenes/settings.tscn")

# references of scenes inside of other scenes.
const KEYBIND_SCENE := preload("res://scenes/keybind.tscn") # inside of settings
 
# main menu texture
var main_screen: TextureRect

# scenes
var main_menu: Node2D
var how_to_play_scene: Control
var settings_scene: Control
var keybind_scene: Control
 
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
 
## Initialize the main menu panels and wire their controls.
func _ready() -> void:
	_instantiate_scenes()
	_connect_panel_signals()
	_setup_initial_state()
 
func _instantiate_scenes() -> void:
	main_screen = get_node("Main Screen")
	main_menu = get_node("MainMenuTitle")
 
	how_to_play_scene = HOW_TO_PLAY_SCENE.instantiate()
	how_to_play_scene.name = "HowToPlay"
	add_child(how_to_play_scene)
	how_to_play_scene.owner = self
	how_to_play_scene.visible = false
 
	settings_scene = SETTINGS_SCENE.instantiate()
	settings_scene.name = "Settings"
	add_child(settings_scene)
	settings_scene.owner = self
	settings_scene.visible = false

	keybind_scene = KEYBIND_SCENE.instantiate()
	keybind_scene.name = "Keybind"
	add_child(keybind_scene)
	keybind_scene.owner = self
	keybind_scene.visible = false

func _connect_panel_signals() -> void:
	# references to cursors
	cursor_start = get_node("MainMenuTitle/VBoxContainer/StartNode/StartCursor")
	cursor_htp = get_node("MainMenuTitle/VBoxContainer/HTPNode/HTPCursor")
	cursor_quit = get_node("MainMenuTitle/VBoxContainer/QuitNode/QuitCursor")
	cursor_settings = get_node("MainMenuTitle/VBoxContainer/SettingsNode/SettingsCursor")
 
	# references to buttons
	start_button = get_node("MainMenuTitle/VBoxContainer/StartNode/start game")
	howtoplay_button = get_node("MainMenuTitle/VBoxContainer/HTPNode/howtoplay game")
	quit_button = get_node("MainMenuTitle/VBoxContainer/QuitNode/quit game")
	settings_button = get_node("MainMenuTitle/VBoxContainer/SettingsNode/settings")
	
	# references to text
	start_text = get_node("MainMenuTitle/VBoxContainer/StartNode/StartText")
	htp_text = get_node("MainMenuTitle/VBoxContainer/HTPNode/HowToPlayText")
	quit_text = get_node("MainMenuTitle/VBoxContainer/QuitNode/QuitText")
	settings_text = get_node("MainMenuTitle/VBoxContainer/SettingsNode/SettingsText")
	
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
	
	# references to quit
	settings_button.focus_entered.connect(_on_settings_focus_entered)
	settings_button.focus_exited.connect(_on_settings_focus_exited)
	settings_button.pressed.connect(_on_settings_pressed)
 
	# Panels notify us when their own "back" button is pressed.
	how_to_play_scene.back_pressed.connect(_on_how_to_play_back_pressed)
	how_to_play_scene.tutorial_pressed.connect(_on_tutorial_pressed)
	settings_scene.back_pressed.connect(_on_settings_back_pressed)
	settings_scene.keybind_pressed.connect(_on_settings_keybind_pressed)
	keybind_scene.back_pressed.connect(_on_keybind_back_pressed)


func _set_main_menu_visible(visible: bool) -> void:
	main_screen.visible = visible
	main_menu.visible = visible
 
func _setup_initial_state() -> void:
	_set_main_menu_visible(true)
 
	start_button.grab_focus()
	how_to_play_scene.visible = false
	settings_scene.visible = false
	keybind_scene.visible = false
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
	_set_main_menu_visible(false)
	how_to_play_scene.visible = true
	settings_scene.visible = false
	keybind_scene.visible = false
	how_to_play_scene.focus_back_button()

func _on_tutorial_pressed() -> void:
	_set_main_menu_visible(false)
	how_to_play_scene.visible = false
	settings_scene.visible = false
	keybind_scene.visible = false
 
func _on_howtoplay_game_focus_exited() -> void:
	cursor_htp.visible = false
	htp_text.unfocused()
 
func _on_howtoplay_game_focus_entered() -> void:
	cursor_htp.visible = true
	htp_text.focused()
 
## Goes to Settings
func _on_settings_pressed() -> void:
	_set_main_menu_visible(false)
	how_to_play_scene.visible = false
	settings_scene.visible = true
	keybind_scene.visible = false
	settings_scene.focus_first_control()

func _on_settings_keybind_pressed() -> void:
	_set_main_menu_visible(false)
	how_to_play_scene.visible = false
	settings_scene.visible = false
	keybind_scene.visible = true
	keybind_scene.focus_back_button()
 
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
	_set_main_menu_visible(true)
	how_to_play_scene.visible = false
	settings_scene.visible = false
	keybind_scene.visible = false
 
## Go back to main menu (From the Settings)
func _on_settings_back_pressed() -> void:
	_set_main_menu_visible(true)
	how_to_play_scene.visible = false
	settings_scene.visible = false
	keybind_scene.visible = false
	settings_button.grab_focus()

## Go back to settings (From Keybind)
func _on_keybind_back_pressed() -> void:
	_set_main_menu_visible(false)
	how_to_play_scene.visible = false
	settings_scene.visible = true
	keybind_scene.visible = false
	settings_scene.focus_keybind_control()
