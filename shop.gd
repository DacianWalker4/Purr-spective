extends Node2D

@onready var UI = $Inv_UI

var player = null

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_delete"):  # Assuming "ui_delete" is the action name for "P"
		UI.delete_item()
