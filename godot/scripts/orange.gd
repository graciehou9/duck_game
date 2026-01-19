extends Area2D

const SPEED = 550.0

func _physics_process(delta: float) -> void:
	# Move the orange UP
	position.y -= SPEED * delta

	# Delete if it goes off the top of the screen to save memory
	if position.y < -50:
		queue_free()
