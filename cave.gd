extends AudioStreamPlayer2D

@onready var cave = $"."

func _ready():
	cave.play()

func _on_finished():
	cave.play()
