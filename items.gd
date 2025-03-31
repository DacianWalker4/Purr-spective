extends Node2D

@export var item: InvItem
@export var item_id: String  # Unique ID for the item
@export var coin_amount: int = 1  # Default coin amount, can be overridden in derived scenes
@onready var key_f = $KeyF

var player = null

func _ready():
	key_f.visible = false
	key_f.play("normal")
	set_process(true)

	# Check if this item has already been collected
	if StageManager.is_item_collected(item_id):
		queue_free()  # Remove the item if it's already collected

func _process(_delta):
	if player and Input.is_action_just_pressed("interact"):
		playercollect()
		await get_tree().create_timer(0.1).timeout
		queue_free()

func _on_item_area_body_entered(body):
	if body.has_method("collect"):
		key_f.visible = true
		player = body

func _on_item_area_body_exited(body):
	if body == player:
		player = null

func playercollect():
	if player:
		key_f.play("pressed")
		player.collect(item)
		StageManager.mark_item_as_collected(item_id)  # Mark the item as collected
