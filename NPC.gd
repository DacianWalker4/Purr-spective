extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

@onready var Here = $"!"
@export var dialogue_ressource: DialogueResource
@export var dialogue_start: String = "start"
@export var always_idle: bool = false

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	Here.visible = true

func _process(delta):
	if always_idle:
		$AnimatedSprite2D.play("idle")
	else:
		if current_state == IDLE or current_state == 1:
			$AnimatedSprite2D.play("idle")
		elif current_state == 2 and !is_chatting:
			if dir.x == -1:
				$AnimatedSprite2D.play("walk_left")
			elif dir.x == 1:
				$AnimatedSprite2D.play("walk_right")
			elif dir.y == -1:
				$AnimatedSprite2D.play("walk_up")
			elif dir.y == 1:
				$AnimatedSprite2D.play("walk_down")

		if is_roaming:
			match current_state:
				IDLE:
					pass
				NEW_DIR:
					dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				MOVE:
					move(delta)

	# Check if the player is in the chat detection area before allowing them to initiate chat
	if Input.is_action_just_pressed("chat") and player_in_chat_zone:
		Here.visible = false
		print("chat")
		DialogueManager.show_dialogue_balloon(dialogue_ressource, dialogue_start)
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(30).timeout
		is_roaming = true
		is_chatting = false

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta
		velocity = dir * speed * delta
	move_and_collide(velocity)

func _on_chat_detection_area_body_entered(body):
	if body.has_method("is_in_group") and body.is_in_group("player"):  
		player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body):
	if body.has_method("is_in_group") and body.is_in_group("player"):
		player_in_chat_zone = false

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])

