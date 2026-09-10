extends Control
class_name LetterEntry

@export var letter_display : Label
@export var arrows : Control

const LETTERS := [
	" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "!",
	"?", "#", "$", "*", "(", ")"]

const SYMBOL_COUNT := len(LETTERS)

var current_letter : String
var current_index : int = 0

func _ready() -> void:
	set_letter()

func set_letter():
	current_letter = LETTERS[current_index]
	letter_display.text = current_letter

func increment_letter():
	current_index += 1
	if current_index == SYMBOL_COUNT:
		current_index -= SYMBOL_COUNT
	set_letter()

func decrement_letter():
	current_index -= 1
	if current_index == -1:
		current_index = SYMBOL_COUNT-1
	set_letter()

func _process(delta: float) -> void:
	if has_focus():
		if Input.is_action_just_pressed("ui_down"):
			increment_letter()
		if Input.is_action_just_pressed("ui_up"):
			decrement_letter()

func _on_focus_entered() -> void:
	arrows.visible = true

func _on_focus_exited() -> void:
	arrows.visible = false
