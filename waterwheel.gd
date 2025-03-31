extends AnimatedSprite2D

@onready var wheel = $"."

func _ready():
	wheel.play("on")
