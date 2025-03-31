extends AudioStreamPlayer2D

@onready var a = $"."

func _ready():
	a.play()


func _on_finished():
	a.play()
