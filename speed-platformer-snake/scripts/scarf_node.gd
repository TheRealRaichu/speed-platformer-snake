class_name ScarfNode
extends Line2D

var collision_box

# timers
var activation_time : float # time it takes to activate
var lifespan : float # total time alive
var elapsed_time : float # time passed since the scarf node spawned

# status
var activate := func(): is_active = true; self.default_color = Color.PURPLE
var is_active := false

signal lifespan_over # when should die, ask manager to kill it

func _ready() -> void:
	# initialize timers
	get_tree().create_timer(activation_time, false).timeout.connect(activate)
	get_tree().create_timer(lifespan, false).timeout.connect(lifespan_over.emit)
	# Moved and edited the initialzied timers into _process to be able to pause the scarf once used.
	init_hitbox()

# Pauses the lifepsan and activation timers of the scarf when player pauses the game
func _process(delta: float) -> void:
	# Creates a timer
	elapsed_time += delta
	if not is_active and elapsed_time >= activation_time: # If both true, then can run the activation of the scarf. If not, then pauses the scarf.
		activate.call()
	if elapsed_time >= lifespan: # If true, then continue running. False pauses the lifespan of the scarf.
		lifespan_over.emit()

func init_hitbox():
	# initialize hitbox
	collision_box = Area2D.new()
	collision_box.set_collision_layer_value(3, true)
	add_child(collision_box)
	var collision = CollisionShape2D.new()
	var segment = SegmentShape2D.new()
	# Define segment points based on line
	segment.a = points[0]
	segment.b = points[1]
	collision.shape = segment
	collision_box.add_child(collision)

func die(): # death
	self.queue_free()
