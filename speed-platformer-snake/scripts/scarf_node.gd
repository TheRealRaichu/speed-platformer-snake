class_name ScarfNode
extends Line2D

var collision_box

# timers
var activation_time : float # time it takes to activate
var lifespan : float # total time alive
# status
var activate := func(): is_active = true; self.default_color = Color.PURPLE
var is_active := false

signal lifespan_over # when should die, ask manager to kill it

func _ready() -> void:
	# initialize timers
	get_tree().create_timer(activation_time, false).timeout.connect(activate)
	get_tree().create_timer(lifespan, false).timeout.connect(lifespan_over.emit)
	init_hitbox()

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
