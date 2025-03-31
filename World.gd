extends Node2D

@onready var rat_scene = preload("res://ennemies/RatRun.tscn")
@onready var royal_arrival = $Music_sfx/RoyalArrival
@onready var s_word = $Music_sfx/SWord
@onready var swordsfx = $Music_sfx/Swordsfx
@onready var npcs = $"Npc's"
@onready var dwarf = $Music_sfx/Dwarf

var wolf = preload("res://ennemies/Wolf.tscn")
var HOUR: String = ""
var hasPrintedSpook = false
var wolf_instances = []  # Array to keep track of wolf instances

var wolf_positions = [
	Vector2(-591, -32),
	Vector2(-587, -571),
	Vector2(-53, -932),
	Vector2(847, -839),
	Vector2(1016, -375),
	Vector2(1651, -187),
	Vector2(1849, 147)
]

func _ready():
	var rat_instance = rat_scene.instantiate()
	rat_instance.position = Vector2(890, 890)
	rat_instance.scale = Vector2(0.7, 0.7)
	add_child(rat_instance)
	swordsfx.play()
	s_word.play()
	npcs.visible = true
	await get_tree().create_timer(100).timeout
	royal_arrival.play()
	StageManager.coin_icon.visible = true
	StageManager.coin_label.visible = true
	_check_and_spawn_or_despawn_wolves()  # Ensure wolves are correctly spawned or despawned

func _on_s_word_finished():
	swordsfx.play()
	s_word.play()

func _spawn_wolves():
	for pos in wolf_positions:
		var wolf_instance = wolf.instantiate()
		wolf_instance.position = pos
		wolf_instance.scale = Vector2(1, 1)
		wolf_instance.z_index = 2
		add_child(wolf_instance)
		wolf_instances.append(wolf_instance)
	print("spook")

func _despawn_wolves():
	for wolf_instance in wolf_instances:
		if is_instance_valid(wolf_instance):
			wolf_instance.queue_free()
	wolf_instances.clear()

func _physics_process(_delta):
	_check_and_spawn_or_despawn_wolves()

func _check_and_spawn_or_despawn_wolves():
	if (StageManager.hour >= 20 or StageManager.hour < 5) and not hasPrintedSpook:
		HOUR = "night"
		_spawn_wolves()
		npcs.visible = false
		hasPrintedSpook = true
	elif StageManager.hour >= 5 and StageManager.hour < 20 and hasPrintedSpook:
		HOUR = "morning"
		hasPrintedSpook = false
		_despawn_wolves()
		npcs.visible = true

func _on_dwarf_finished():
	dwarf.play()
