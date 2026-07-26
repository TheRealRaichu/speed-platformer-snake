extends Control
 
## HOW TO PLAY
signal back_pressed
signal tutorial_pressed
 
var back_button: Button
var play_button: Button

var back_cursor: Control
var play_cursor: Control

var back_text: TextureRect
var play_text: TextureRect
 
func _ready() -> void:
	# references to buttons
	play_button = get_node("TutorialPlayNode/tutorial")
	back_button = get_node("BackNode/back")

	# references to cursors
	play_cursor = get_node("TutorialPlayNode/PlayCursor")
	back_cursor = get_node("BackNode/BackCursor")

	# references to text
	play_text = get_node("TutorialPlayNode/PlayTutorialText")
	back_text = get_node("BackNode/BackText")

	# switching between the nodes.
	play_button.focus_entered.connect(_on_play_focus_entered)
	play_button.focus_exited.connect(_on_play_focus_exited)
	back_button.focus_entered.connect(_on_back_focus_entered)
	back_button.focus_exited.connect(_on_back_focus_exited)

	# set cursors visibilitiy
	play_cursor.visible = false
	back_cursor.visible = true

	back_button.pressed.connect(_on_back_pressed)
	play_button.pressed.connect(_on_tutorial_pressed)
 
## Called by the main menu script right after this panel is shown.
func focus_back_button() -> void:
	back_button.grab_focus()

func _on_play_focus_entered() -> void:
	play_cursor.visible = true
	play_text.focused()

func _on_play_focus_exited() -> void:
	play_cursor.visible = false
	play_text.unfocused()

func _on_back_focus_entered() -> void:
	back_cursor.visible = true
	back_text.focused()

func _on_back_focus_exited() -> void:
	back_cursor.visible = false
	back_text.unfocused()
 
func _on_back_pressed() -> void:
	back_pressed.emit()

func _on_tutorial_pressed() -> void:
	tutorial_pressed.emit()
