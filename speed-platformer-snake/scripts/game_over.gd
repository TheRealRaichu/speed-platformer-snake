extends Menu
var scene_manager
var player

## GAME OVER SCREEN

# child reference
@export var restart_button : UIButton
@export var leaderboard_button : UIButton
@export var quit_button : UIButton
@export var days_label : Label
@export var score_label : Label

@export var leaderboard_scene : PackedScene
var score_registered : bool = false

func _ready() -> void:
	display_score() # display score of game
	restart_button.grab_focus() # restart button takes focus for key navigation

func display_days():
	score_label.text = "days survived: " + str(Globals.day_count - 1)

func display_score():
	score_label.text = "score: " + str(Globals.score)

## Restarts game
func _on_try_again_pressed() -> void:
	scene_manager.start_game()

## Opens leaderboard menu
func _on_leaderboard_pressed() -> void:
	var leaderboard_inst = leaderboard_scene.instantiate() as LeaderboardUI
	leaderboard_inst.earned_score = Globals.score
	leaderboard_inst.closed.connect(leaderboard_closed)
	enbacken(true)
	# add to scene manager for modulate and input indpendence!
	add_sibling(leaderboard_inst)

## Quits to Main Menu
func _on_quit_pressed() -> void:
	scene_manager.main_menu()

func leaderboard_closed():
	enbacken(false)
	leaderboard_button.grab_focus()
