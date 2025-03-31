extends Area2D

# Assuming nodes are correctly referenced in your scene
@onready var sleeping_cat = $"../SleepingCat"
@onready var player = $"../Player"
@onready var purr = $"../Purr"
@onready var old = $old
@onready var key = $KeyF
@onready var fog = $"../CanvasModulate"

var is_awake = false
var player_inside = false

func _ready():
	sleeping_cat.play("sleep")
	if StageManager.started_game == "":
		fog.visible = true
		toggle_awake_state()
		old.play()
		key.visible = true
		StageManager.started_game = "started"
		key.visible = false
	else:
		fog.visible = false
		key.visible = false
		sleeping_cat.visible = false  # Start with the cat hidden (sleeping state)
		sleeping_cat.play("sleep")
		player.visible = true
		key.visible = false
		old.play()

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true
		key.visible = true
		if StageManager.started_game == "":
			key.visible = false

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false
		key.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_inside:
		toggle_awake_state()

func toggle_awake_state():
	is_awake = !is_awake  # Toggle the awake state
	
	if is_awake:
		sleeping_cat.visible = true
		fog.visible = true
		sleeping_cat.play("sleep")
		player.visible = false
		key.visible = false
		purr.play()
		await get_tree().create_timer(15).timeout
		StageManager.hour += 8
		key.visible = true
	else:
		fog.visible = false
		purr.stop()
		sleeping_cat.visible = false
		player.visible = true
		key.visible = false
		key.visible = false

func _on_old_finished():
	old.play()
