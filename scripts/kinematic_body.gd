extends KinematicBody

var velocity := Vector3.ZERO

func _physics_process(delta):
	velocity.y -= 9.8 * delta
	velocity = move_and_slide(velocity, Vector3.UP)
