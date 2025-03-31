extends Node2D

@onready var a = $a
@onready var b = $b
@onready var c = $c
@onready var d = $d


func _ready():
	a.play()
	b.play()
	c.play()
	d.play()



func _on_a_finished():
	await get_tree().create_timer(1.5).timeout
	a.play()


func _on_b_finished():
	await get_tree().create_timer(2).timeout
	b.play()


func _on_c_finished():
	await get_tree().create_timer(1).timeout
	c.play()


func _on_d_finished():
	await get_tree().create_timer(4).timeout
	d.play()
