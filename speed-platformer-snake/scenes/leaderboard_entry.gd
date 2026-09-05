extends HBoxContainer
class_name LeaderboardEntry

@export var player_name_label : Label
@export var player_score_label : Label

var player_name : String
var player_score : int

func _ready() -> void:
	player_name_label.text = player_name
	player_score_label.text = str(player_score)
