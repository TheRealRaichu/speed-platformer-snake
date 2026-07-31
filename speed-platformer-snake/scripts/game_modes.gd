extends Control

## GAME MODES
# reference to scenemanager, set when initialized
var scene_manager

# scene references
@onready var main_screen := $"Main Screen"

# mode panels
@onready var normal_mode := $NormalMode
@onready var practice_mode := $PracticeMode
@onready var two_player_mode := $"2PlayerMode"
@onready var back_mode := $Back

# buttons
@onready var normal_button := $NormalMode/normal
@onready var practice_button := $PracticeMode/practice
@onready var two_player_button := $"2PlayerMode/2player"
@onready var back_button := $Back/back

# cursors
@onready var normal_cursor := $NormalMode/NormalCursor
@onready var practice_cursor := $PracticeMode/PracticeCursor
@onready var two_player_cursor := $"2PlayerMode/2PlayerCursor"
@onready var back_cursor := $Back/BackCursor

# texts
@onready var normal_text := $NormalMode/NormalText
@onready var practice_text := $PracticeMode/PracticeText
@onready var two_player_text := $"2PlayerMode/2PlayerText"

func _ready() -> void:
	_connect_controls()
	_setup_initial_state()

func _connect_controls() -> void:
	normal_button.focus_entered.connect(_on_normal_focus_entered)
	normal_button.focus_exited.connect(_on_normal_focus_exited)
	normal_button.pressed.connect(_on_normal_pressed)

	practice_button.focus_entered.connect(_on_practice_focus_entered)
	practice_button.focus_exited.connect(_on_practice_focus_exited)
	practice_button.pressed.connect(_on_practice_pressed)

	two_player_button.focus_entered.connect(_on_two_player_focus_entered)
	two_player_button.focus_exited.connect(_on_two_player_focus_exited)
	two_player_button.pressed.connect(_on_two_player_pressed)

	back_button.focus_entered.connect(_on_back_focus_entered)
	back_button.focus_exited.connect(_on_back_focus_exited)
	back_button.pressed.connect(_on_back_pressed)

func _setup_initial_state() -> void:
	main_screen.visible = true
	normal_mode.visible = true
	practice_mode.visible = true
	two_player_mode.visible = true
	back_mode.visible = true

	normal_cursor.visible = false
	practice_cursor.visible = false
	two_player_cursor.visible = false
	back_cursor.visible = false

	normal_button.grab_focus()

func _on_normal_pressed() -> void:
	scene_manager.normal_mode()

func _on_normal_focus_entered() -> void:
	normal_cursor.visible = true
	normal_text.focused()

func _on_normal_focus_exited() -> void:
	normal_cursor.visible = false
	normal_text.unfocused()

func _on_practice_pressed() -> void:
	scene_manager.practice_mode()

func _on_practice_focus_entered() -> void:
	practice_cursor.visible = true
	practice_text.focused()

func _on_practice_focus_exited() -> void:
	practice_cursor.visible = false
	practice_text.unfocused()

func _on_two_player_pressed() -> void:
	scene_manager.two_player_mode()

func _on_two_player_focus_entered() -> void:
	two_player_cursor.visible = true
	two_player_text.focused()

func _on_two_player_focus_exited() -> void:
	two_player_cursor.visible = false
	two_player_text.unfocused()

func _on_back_pressed() -> void:
	scene_manager.main_menu()

func _on_back_focus_entered() -> void:
	back_cursor.visible = true

func _on_back_focus_exited() -> void:
	back_cursor.visible = false