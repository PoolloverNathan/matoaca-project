extends Node2D
export var MAX_RIGHTING_FORCE = 5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass

func _integrate_forces(state: Physics2DDirectBodyState):
	state.angular_velocity = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
