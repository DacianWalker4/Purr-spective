extends CharacterBody2D

@onready var rat = $AnimatedSprite2D
@export var speed = 50

enum Behavior {
	RUN_AWAY,
	RUN_TOWARDS
}

@export var behavior: Behavior = Behavior.RUN_AWAY

var player_position = Vector2.ZERO
var player = null
var is_alive = true  # Flag to track if rat is alive
var player_in_area = false  # Flag to track if player is in the RunAwayArea

func _ready():
	player = get_parent().get_node("Player")
	rat.play("idle")
	if !player:
		print("Error: 'Player' node not found.")

	if !rat:
		print("Error: 'rat' AnimatedSprite2D node not found.")
	else:
		rat.play("idle")

func _physics_process(delta):
	if !player:
		return  # Stop processing if player is not found

	if !is_alive:
		return  # Stop processing if rat is dead

	if player_in_area:  # Only move if player is in the area
		player_position = player.position
		var target_position = Vector2.ZERO

		if behavior == Behavior.RUN_AWAY:
			target_position = (position - player_position).normalized()
		elif behavior == Behavior.RUN_TOWARDS:
			target_position = (player_position - position).normalized()

		if position.distance_to(player_position) > 3:
			move_and_collide(target_position * speed * delta)

			if abs(target_position.x) > abs(target_position.y):
				if target_position.x > 0:
					rat.play("walk_right")
				else:
					rat.play("walk_left")
			else:
				if target_position.y > 0:
					rat.play("walk_down")
				else:
					rat.play("walk_up")

func _on_area_2d_body_entered(body):
	if body == player:
		is_alive = false
		queue_free_rat()

func queue_free_rat():
	if rat:
		queue_free()
		StageManager.rat_status = "dead"
		var stage_manager = get_node("/root/StageManager")  # Adjust path as necessary
		if stage_manager:
			if behavior == Behavior.RUN_AWAY:
				stage_manager.increment_coin_count(1)
			elif behavior == Behavior.RUN_TOWARDS:
				if stage_manager.coin_count > 3:
					stage_manager.increment_coin_count(-3)
				else:
					return
		else:
			print("Error: StageManager node not found.")
	else:
		print("Error: Rat node is null.")

func _on_run_away_area_body_entered(body):
	if body == player:
		player_in_area = true


func _on_run_away_area_body_exited(body):
	if body == player:
		player_in_area = false
		rat.play("idle")
