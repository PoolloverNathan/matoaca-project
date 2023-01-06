extends RigidBody2D
signal healthchange(newValue)
signal die(reason)
export var h_rate = 0.1
export var terminal_velocity = 30.0
export var offset_rate = 0.5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

var dead: bool = false
var current_velocity = Vector2(0, 0)
export var jump_power = 20.0
export var move_force = 20.0
export var offset_force = 20.0
export var gravity = Vector2(0, -9.8)

func die(reason):
	emit_signal("healthchange", 0)
	emit_signal("die", reason)
	dead = true
	
func _process(delta):
	var desired_velocity = Vector2(0, 0)
	var desired_offset = Vector2(0, 0)
	var instant_velocity = false
	if not dead:
		# Get values
		var h_move = Input.get_axis("move_left", "move_right")
		var v_move = Input.get_axis("move_up", "move_down")
		var jump = Input.get_action_strength("jump")
		var effectiveJump = int(bool(jump)) * jump_power
		var look = int(bool(int(Input.get_action_strength("activate_look"))))
		if not look:
			add_force(Vector2(0, 0), Vector2(h_move, 0))
	var cam: Camera2D = $camera
	cam.transform = cam.transform.interpolate_with(desired_offset, offset_rate)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_exit_screen():
	die("exited_screen")

func goto(pos: Position2D, revive: bool):
	global_transform = pos.global_transform
	dead = dead || revive
