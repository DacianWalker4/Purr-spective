extends AnimatedSprite2D
@onready var key = $"."

var player = null

func _ready():
	key.play("normal")
	key.visible = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_delete"):
		key.play("pressed")
		await get_tree().create_timer(1).timeout
		key.play("normal")
func _on_area_2d_body_entered(body):
	if body.has_method("collect"):
		key.visible = true


func _on_area_2d_body_exited(body):
	if body.has_method("collect"):
		key.visible = false

