extends Node2D

@onready var plant = $plant
@onready var label = $key
@onready var plant_picking = $plant_picking

var player = null
var isFullyGrown = false
var isPicked = false  # Track whether the plant has been picked

func _ready():
	plant.play("idle")
	label.visible = false

func _on_harvesting_area_body_entered(body):
	if body.name == "Player":
		player = body
		var stage_manager = get_node("/root/StageManager")
		if stage_manager:
			plant.play("growing")
			await get_tree().create_timer(2).timeout  # Simulated growth time
			isFullyGrown = true
			label.visible = true
		else:
			plant.play("idle")

func _on_harvesting_area_body_exited(body):
	if body.name == "Player":
		player = null
		label.visible = false

func _input(event):
	if event.is_action_pressed("interact"):
		if player and isFullyGrown and not isPicked:
			var stage_manager = get_node("/root/StageManager")
			if stage_manager:
				plant_picking.play()
				plant.play("idle")  # Play "idle" animation when "interact" (F key) is pressed
				label.visible = false
				isPicked = true
				stage_manager.plants_owned(1)
