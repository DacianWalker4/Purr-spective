extends Node2D

@onready var sleeping_cat = $SleepingCat
@onready var foam = $foam
@onready var foam_2 = $foam2
@onready var foam_3 = $foam3
@onready var about_2 = $About2
@onready var quit_2 = $About2/Quit2
@onready var options_2 = $Options2
@onready var click = $click
@onready var day_soundscape = $DaySoundscape
@onready var purr = $Purr


func _ready():
	sleeping_cat.play("sleep")
	foam.play("default")
	foam_2.play("default")
	foam_3.play("default")
	options_2.visible = false
	about_2.visible = false
	day_soundscape.play()
	purr.play()
	updateUI()

func _on_quit_pressed():
	click.play()
	get_tree().quit()


func _on_play_pressed():
	click.play()
	get_tree().change_scene_to_file("res://houses/Spawn.tscn")
	


func _on_options_pressed():
	click.play()
	options_2.visible = true


func _on_about_pressed():
	click.play()
	about_2.visible = true
	quit_2.visible = true


func _on_quit_2_pressed():
	click.play()
	about_2.visible = false
	quit_2.visible = false
	


func _on_quit_3_pressed():
	click.play()
	options_2.visible = false


func _on_day_soundscape_finished():
	day_soundscape.play()


func _on_purr_finished():
	purr.play()


func _on_language_language_changed():
	updateUI()

func updateUI():
	$Options2/Label.text = tr("OPTIONS")
	$Options2/Label2.text = tr("GENERAL")
	$Options2/Label3.text = tr("SFX")
	$Options2/Label4.text = tr("MUSIC")
	$About2/AboutText.text = tr("ABOUTTEXT")
	$About2/AboutText1.text = tr("ABOUTTEXT1")
	$Options2/Label5.text = tr("C")
	$Options2/Label6.text = tr("M")
	$Options2/Label7.text = tr("F")
	$Options2/Label8.text = tr("P")
	$Options2/Label9.text = tr("SPACE")
	$Options2/Controles.text = tr("CONTROLES")
