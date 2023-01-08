class_name Player extends KinematicBody2D
# signal win()
# signal get_collectable(color)
signal reload()

export var GRAVITY_VEC = Vector2(0, 900)
export var FLOOR_NORMAL = Vector2(0, -1)
export var SLOPE_SLIDE_STOP = 25.0
export var WALK_SPEED = 250 # pixels/sec
export var JUMP_SPEED = 480
export var SIDING_CHANGE_SPEED = 10
export var TIME_FOR_SEVERE_FALL = 1
export var TIME_FOR_FATAL_FALL = 5
export var FALL_SPLAT_TIME = 1
export var DOUBLE_JUMP_THRESHOLD = 0.5
export var COYOTE_THRESHOLD = 0.25
onready var TREE: AnimationTree = $AnimationPlayer/AnimationTree

var linear_vel = Vector2()
var fall_time = 0
var fall_splat_time = 0
var can_double_jump = true
var coyote = 0

var anim = ""

# cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Body

func _ready():
	pass

func _physics_process(delta):
	if transform.origin.y > 480:
		emit_signal("reload")
		return
	# print("delta " + str(delta) + " vel " + str(linear_vel) + " fall " + str(fall_time) + " splat " + str(fall_splat_time))
	### MOVEMENT ###

	# Apply gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()
	if on_floor:
		coyote = 0
	else:
		coyote += delta
		if coyote < COYOTE_THRESHOLD:
			on_floor = true
	if fall_splat_time > 0:
		fall_splat_time -= delta
		return

	### CONTROL ###

	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("move_left"):
		target_speed -= 1
	if Input.is_action_pressed("move_right"):
		target_speed += 1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if (on_floor or (can_double_jump and not $FloorCast.is_colliding())) and Input.is_action_just_pressed("jump"):
		linear_vel.y = -JUMP_SPEED
		if not on_floor:
			can_double_jump = false
		# ($SoundJump as AudioStreamPlayer2D).play()
	if on_floor:
		can_double_jump = true

	### ANIMATION ###

	var moving = false
	# warning-ignore:unused_variable
	var left = false
	# warning-ignore:unused_variable
	var right = false
	var jumping = false
	var falling = false
	var splat = false

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			moving = true
			left = true

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			moving = true
			right = true
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			sprite.scale.x = -1
			left = true
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			sprite.scale.x = 1
			right = true

		if linear_vel.y < 0:
			jumping = true
		else:
			falling = true
			fall_time += delta
	if not falling:
		if fall_time > TIME_FOR_SEVERE_FALL:
			splat = true
			fall_splat_time = FALL_SPLAT_TIME
		fall_time = 0
	TREE["parameters/conditions/moving"] = moving
	TREE["parameters/conditions/not_moving"] = not moving
	TREE["parameters/conditions/jumping"] = jumping
	# TREE["parameters/conditions/not_jumping"] = not jumping
	# TREE["parameters/conditions/falling"] = falling
	# TREE["parameters/conditions/not_falling"] = not falling
	# TREE["parameters/conditions/splat"] = splat
	# TREE["parameters/conditions/not_splat"] = not splat


func _on_Area2D_body_entered(body):
	if body.is_in_group("fatal_to_touch"):
		emit_signal("reload")
