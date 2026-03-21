extends Node2D

## BACKGROUND
# child ref
@onready var anim_sprite := $AnimatedSprite2D

const TRANSITION_HANG := .2 # time spent in middle of transition
var is_day := true # currently day?


func transition(): # enact transition
	if is_day:
		anim_sprite.play("transition_to_night")
		await anim_sprite.animation_finished
		await get_tree().create_timer(TRANSITION_HANG).timeout
		anim_sprite.play("transition_to_day")
	else:
		anim_sprite.play("transition_to_day")
		await anim_sprite.animation_finished
		await get_tree().create_timer(TRANSITION_HANG).timeout
		anim_sprite.play("transition_to_night")
