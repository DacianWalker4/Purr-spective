extends Button

@onready var bu = $Bu



func _on_mouse_entered():
	bu.play("hover")


func _on_mouse_exited():
	bu.play("idle")

func _ready():
	bu.play("idle")
