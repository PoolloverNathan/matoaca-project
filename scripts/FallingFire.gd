extends RigidBody2D

func _on_body_entered(body):
	if body is Player:
		JavaScript.eval("alert('player!')")		
		mode = RigidBody2D.MODE_KINEMATIC
	else:
		JavaScript.eval("alert('not player')")
