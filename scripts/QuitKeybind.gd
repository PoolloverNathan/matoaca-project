extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if Input.is_key_pressed(KEY_Q) and Input.is_key_pressed(KEY_CONTROL):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
