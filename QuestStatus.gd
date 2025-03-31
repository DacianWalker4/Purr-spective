extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		StageManager.cave_status = "explored"
