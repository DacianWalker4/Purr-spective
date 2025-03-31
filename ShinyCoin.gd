# coin.gd
extends Node2D

@onready var sprite_2d = $Sprite2D

@export var chest_id: String

var player = null

func _ready():
	sprite_2d.play("shine")
	if StageManager.is_chest_opened(chest_id):
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body
		StageManager.mark_chest_as_opened(chest_id)
		StageManager.increment_coin_count(1)
		queue_free()
