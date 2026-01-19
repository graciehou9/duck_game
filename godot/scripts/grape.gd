extends Area2D

const SPEED = 250.0

func	 reset_grape():
	position.y = -50    

func _physics_process(delta: float) -> void:
	
	position.y += SPEED*delta
	
	if position.y > 600:
		reset_grape()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		$Squawk.play()
		body.lives -= 1
		reset_grape()
	if "hit_timer" in body:
		body.hit_timer = 0.5

func _on_area_entered(area: Area2D) -> void:
	if area.name.to_lower().begins_with("orange"):
		$Chew.play()
		area.queue_free()
		reset_grape()
		var player = get_parent().get_node("player")
		if player:
			player.score+=1
