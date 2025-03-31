extends Area2D

@export var scene_key: String = "MAIN"
@export var x: int = 0
@export var y: int = 0

func _on_body_entered(body):
	if body.name == "Player":
		StageManager.changeStage(scene_key, x, y)
