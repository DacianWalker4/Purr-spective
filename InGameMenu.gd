extends Node2D

@onready var options_2 = $Options2
@onready var sure_ = $"Options2/Sure?"
@onready var click = $"../click"


func _ready():
	click.play()
	options_2.visible = false
	sure_.visible = false
	

func _on_quit_3_pressed():
	click.play()
	sure_.visible = true

func _physics_process(_delta):
	if Input.is_action_just_pressed("Menu"):
		options_2.visible = not options_2.visible


func _on_back_pressed():
	click.play()
	sure_.visible = false


func _on_quit_pressed():
	click.play()
	get_tree().quit()
