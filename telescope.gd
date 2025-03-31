extends Node2D

@onready var area2d = $Telescope/Area2D
@onready var key = $Key

var player_in_area = false
@onready var starry = $Starry


func _physics_process(_delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		key.play("on")
		starry.visible = true


func _ready():
	key.visible = false
	key.play("off")
	starry.visible = false

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		key.visible = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		key.visible = false
