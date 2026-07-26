extends Control
 
## MAIN MENU
# reference to scenemanager, set when initialized
var scene_manager
 
# main menu texture
var main_screen: TextureRect

# scene references
var main_menu: Node2D
 
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
	_cache_scene_references()
	_connect_panel_signals()
	_setup_initial_state()
 
func _cache_scene_references() -> void:
	main_screen = get_node("Main Screen")
	main_menu = get_node("MainMenuTitle")

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
 
func _set_main_menu_visible(visible: bool) -> void:
	main_screen.visible = visible
	main_menu.visible = visible
 
func _setup_initial_state() -> void:
	_set_main_menu_visible(true)
 
	start_button.grab_focus()
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
 
