extends Node2D

@onready var chest_open = $chest_open

var Item0 = preload("res://inventory/items/CoinsCollectable.tscn")
var Item1 = preload("res://inventory/items/CastleKey.tscn")
var Item2 = preload("res://inventory/items/Cheese.tscn")
var Item3 = preload("res://inventory/items/egg.tscn")
var Item4 = preload("res://inventory/items/Apple.tscn")
var Item5 = preload("res://inventory/items/berry.tscn")
var Item6 = preload("res://inventory/items/Bow.tscn")
var Item7 = preload("res://inventory/items/CakeSlice.tscn")
var Item8 = preload("res://inventory/items/Cup.tscn")
var Item9 = preload("res://inventory/items/egg.tscn")
var Item10 = preload("res://inventory/items/MarriageRing.tscn")
var Item11 = preload("res://inventory/items/Message.tscn")
var Item12 = preload("res://inventory/items/Potion.tscn")
var Item13 = preload("res://inventory/items/Necklace.tscn")
var Item14 = preload("res://inventory/items/ring.tscn")
var Item15 = preload("res://inventory/items/Spear.tscn")
var Item16 = preload("res://inventory/items/StarNecklace.tscn")
var Item17 = preload("res://inventory/items/Sword.tscn")
var Item18 = preload("res://inventory/items/WitchHat.tscn")

var animation_player: AnimationPlayer
@onready var particles: CPUParticles2D = $poof
@onready var key_f = $KeyF

@onready var spawn_area = $spawnArea
@onready var spawn_area2 = $spawnArea2

var player = null
var is_opening = false
@export var chest_id: String  # Unique identifier for the chest

func _ready():
	key_f.visible = false
	animation_player = $AnimationPlayer
	particles.emitting = false

	if StageManager.is_chest_opened(chest_id):
		queue_free()  # Remove the chest if it has already been opened

func _process(_delta):
	if player and Input.is_action_just_pressed("interact") and not is_opening:
		key_f.play("pressed")
		is_opening = true
		open_chest()

func _on_label_area_body_entered(body):
	if body.has_method("collect"):
		player = body
		key_f.visible = true
		key_f.play("normal")

func _on_label_area_body_exited(body):
	if body == player:
		player = null
		key_f.visible = false 

func open_chest():
	animation_player.play("open")
	chest_open.play()
	await get_tree().create_timer(1).timeout
	drop()
	particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	StageManager.mark_chest_as_opened(chest_id)
	queue_free()

func drop():
	var num_items = randi() % 2 + 1  # Randomly choose to drop one or two items

	for i in range(num_items):
		var item_instance = null
		var item_type = randi() % 19  # Generate a random item type
		var item_id = str(randi() % 100 + 1)  # Generate a unique ID for the item

		match item_type:
			0:
				item_instance = Item0.instantiate()
			1:
				item_instance = Item1.instantiate()
			2:
				item_instance = Item2.instantiate()
			3:
				item_instance = Item3.instantiate()
			4:
				item_instance = Item4.instantiate()
			5:
				item_instance = Item5.instantiate()
			6:
				item_instance = Item6.instantiate()
			7:
				item_instance = Item7.instantiate()
			8:
				item_instance = Item8.instantiate()
			9:
				item_instance = Item9.instantiate()
			10:
				item_instance = Item10.instantiate()
			11:
				item_instance = Item11.instantiate()
			12:
				item_instance = Item12.instantiate()
			13:
				item_instance = Item13.instantiate()
			14:
				item_instance = Item14.instantiate()
			15:
				item_instance = Item15.instantiate()
			16:
				item_instance = Item16.instantiate()
			17:
				item_instance = Item17.instantiate()
			18:
				item_instance = Item18.instantiate()

		if item_instance != null:
			if randi() % 2 == 0:
				var _spawnArea = $spawnArea
			else:
				var _spawnArea = $spawnArea2
			item_instance.global_position = spawn_area.global_position
			item_instance.item_id = item_id  # Assign the unique ID to the item
			get_parent().add_child(item_instance)
