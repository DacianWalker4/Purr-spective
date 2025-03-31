extends Node2D

@onready var lever = $lever
@onready var gate = $gate
@onready var label = $key
@onready var gate_collision = $collisions/GateCollision

@onready var lever_2 = $lever2

var player = null
var action_completed = false  # Flag to track if the action has been completed
var collision_freed = false  # Flag to track if gate_collision has been freed

func _ready():
	label.visible = false
	lever.play("off")
	gate.play("close")

func _on_area_2d_body_entered(body):
	if body.name == "Player":  # Assuming the player's node is named "Player"
		player = body
		if not action_completed:
			label.visible = true  # Show the label only if the action is not completed

func _on_area_2d_body_exited(body):
	if body == player:
		player = null
		label.visible = false  # Hide the label when the player leaves the area

func _process(_delta):
	if player and Input.is_action_just_pressed("interact"):
		lever.play("on")
		lever_2.play()
		gate.play("open")
		if not collision_freed:  # Check if gate_collision has been freed
			gate_collision.queue_free()
			collision_freed = true  # Set the flag to true after freeing the collision
		label.visible = false  # Hide the label after interaction
		action_completed = true  # Set the flag to true once the action is completed
