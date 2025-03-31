extends AnimatedSprite2D

@onready var statue = $"."
@onready var label = $key
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var player = null

func _physics_process(_delta):
	statue.play("alive")
	if player and Input.is_action_just_pressed("interact"):
		label.visible = false
		audio_stream_player_2d.play()
		StageManager.statue_status = "done"

func _ready():
	label.visible = false
	# Ensure the label is hidden if the statue status is already accomplished
	if StageManager.statue_status == "done":
		label.visible = false

func _on_take_notes_area_body_entered(body):
	if body.name == "Player":
		player = body
		# Only show the label if the statue status is not yet accomplished
		if StageManager.statue_status != "done":
			label.visible = true

func _on_take_notes_area_body_exited(body):
	if body.name == "Player":
		player = null  # Set player to null when they leave the area
		label.visible = false
