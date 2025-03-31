extends AudioStreamPlayer2D

@onready var old = $"."

func _ready():
	old.play()



func _on_finished():
	old.play()
