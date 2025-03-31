extends Node2D

@onready var door = $Door
@onready var door_opening_sound = $DoorOpeningSound

var player = null

func _ready():
	door.play("close")

func _on_door_area_body_entered(body):
	if body.name == "Player":
		player = body
		door.play("open")
		door_opening_sound.play()


func _on_door_area_body_exited(body):
	if body.name == "Player":
		player = body
		door.play("close")
