extends RigidBody2D
var state: Physics2DDirectBodyState = null
var gravity = Vector2(0, 1)

func _integrate_forces(newState):
	state = newState
	gravity = state.total_gravity
	
