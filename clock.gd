extends Node2D

@onready var label = $Label
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var player = null
var action_completed = false  # Flag to track if the action has been completed

func _ready():
	label.visible = false
	animated_sprite_2d.play("on")
	audio_stream_player_2d.play()

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
		label.visible = false  # Hide the label after interaction
		action_completed = true  # Set the flag to true once the action is completed
		StageManager.clock_status = "done"


func _on_audio_stream_player_2d_finished():
	audio_stream_player_2d.play()
