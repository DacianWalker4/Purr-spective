extends AnimatedSprite2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var label = $key
@onready var forge = $"."
@onready var l = $PointLight2D

var player = null
var forge_activated = false

func _ready():
	forge.play("off")
	label.visible = false
	l.visible = false

func _on_turn_on_area_body_entered(body):
	if body.name == "Player":  # Assuming the player's node is named "Player"
		player = body
		if not forge_activated:
			label.visible = true

func _on_turn_on_area_body_exited(body):
	if body == player:
		player = null
		label.visible = false

func _process(_delta):
	if player and Input.is_action_just_pressed("interact"):  # Ensure "ui_interact" is mapped to "F"
		start_animation()
		label.visible = false
		forge_activated = true

func start_animation():
	forge.play("on")
	audio_stream_player_2d.play()
	StageManager.forge_status = "on"
	l.visible = true

func _on_audio_stream_player_2d_finished():
	audio_stream_player_2d.play()
