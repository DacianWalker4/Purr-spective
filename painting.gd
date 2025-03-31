extends Node2D

@onready var Painting = $AnimationPlayer
@onready var painting = $paintinginframe/painting
@onready var panel = $Panel
@onready var not_enough = $Panel/NotEnough
@onready var coin_icon = $Panel/CoinIcon

@export var dialogue_ressource: DialogueResource

var player_in_area = false
var payment_completed = false

func _ready():
	painting.visible = false
	panel.visible = false
	not_enough.visible = false
	coin_icon.play("shine")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		not_enough.visible = false
		player_in_area = true
		panel.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		panel.visible = false
		Painting.play("goingUp")
		await get_tree().create_timer(1).timeout
		painting.visible = false

func _on_pay_button_pressed():
	if player_in_area and !payment_completed:
		var stage_manager = get_tree().get_root().get_node("StageManager")
		if stage_manager.subtract_coins(10):
			StageManager.paintingCount += 1
			painting.visible = true
			Painting.play("goingDown")
			DialogueManager.show_dialogue_balloon(dialogue_ressource)
			#dialogue.start()
			payment_completed = true  # Mark payment as completed
		else:
			not_enough.visible = true

func _on_quit_button_pressed():
	panel.visible = false
