extends Control

signal language_changed

var languageNames = ["English", "Francais"]
var languageCodes = ["en", "fr"]
@onready var click = $click

func _ready():
	updateUI()

func _on_en_pressed():
	click.play()
	TranslationServer.set_locale("en")
	updateUI()
	emit_signal("language_changed")
	print("en")

func _on_fr_pressed():
	click.play()
	TranslationServer.set_locale("fr")
	updateUI()
	emit_signal("language_changed")
	print("fr")

func updateUI():
	$fr/Label.text = tr("FRENCH")
	$en/Label.text = tr("ENGLISH")
