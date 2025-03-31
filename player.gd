# File path: res://YourScript.gd

extends CharacterBody2D

@export var starting_direction: Vector2 = Vector2(0, 1)
@export var move_speed: float = 50
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var meow_sound = $Meow
@onready var meow_1 = $Meow1
@onready var meow_2 = $Meow2
@onready var meow_3 = $Meow3
@onready var meow_4 = $Meow4
@onready var meow_5 = $Meow5
@onready var meow_6 = $Meow6



@onready var item_ding = $Item_ding

@onready var sprite_2d = $Sprite2D
@onready var actions = $Actions

@onready var light = $PointLight2D

@export var inv: Inv = preload("res://inventory/playerinv.tres")

var action_playing = false
var last_direction = Vector2(0, 1)  # Default direction is down

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)
	actions.visible = false

func _physics_process(delta):
	if StageManager.hour == 20 and StageManager.minute == 0:
		light.visible = true
	elif StageManager.hour == 5 and StageManager.minute == 0:
		light.visible = false
	if action_playing:
		return  # Prevent movement when an action is playing
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed * delta
	move_and_collide(velocity)  # Changed to move_and_slide for smoother movement
	pick_new_state(input_direction)

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		last_direction = move_input  # Update the last direction to the current movement direction
		animation_tree.set("parameters/Walk/blend_position", move_input)
	animation_tree.set("parameters/Idle/blend_position", last_direction)

func pick_new_state(input_direction: Vector2):
	if input_direction != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func pick_random_1_or_2() -> int:
	randomize()  # Initialize the random number generator
	return randi() % 2 + 1

func play_random_meow():
	var meow_sounds = [meow_sound, meow_1, meow_2, meow_3, meow_4, meow_5, meow_6]
	var random_meow = meow_sounds[randi() % meow_sounds.size()]
	random_meow.play()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if Input.is_action_just_pressed("Meow"):
			play_random_meow()
		if Input.is_action_just_pressed("Action"):
			if action_playing:
				actions.stop()
				actions.visible = false
				sprite_2d.visible = true
				action_playing = false
			else:
				var random_number = pick_random_1_or_2()
				if random_number == 1:
					actions.play("sleep")
				else:
					actions.play("pee")
				sprite_2d.visible = false
				actions.visible = true
				action_playing = true

func collect(item):
	item_ding.play()
	inv.insert(item)

func painting():
	pass
