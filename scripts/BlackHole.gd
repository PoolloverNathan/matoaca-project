extends StaticBody2D
var p: Player = null


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayerDeath_body_entered(body):
	if body is Player:
		var cam: Camera2D = body.get_node("camera")
		var campos = cam.global_position
		# cam.force_update_transform()
		cam.get_parent().remove_child(cam)
		add_child(cam)
		cam.global_position = campos
		# cam.drag_margin_h_enabled = false
		# cam.drag_margin_v_enabled = false
		cam.force_update_transform()
		p = body
		get_tree().create_timer(1).connect("timeout", BlackFade, "fadeout")
		get_tree().create_timer(2.5).connect("timeout", self, "p")
func p():
	p.emit_signal("reload")
