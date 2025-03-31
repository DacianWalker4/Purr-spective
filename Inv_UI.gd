extends Control

@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(_delta):
	if Input.is_action_just_pressed("inv"):
		if is_open:
			close()
			StageManager.quests.visible = false
		else:
			open()
			StageManager.quests.visible = true
	#if Input.is_action_just_pressed("ui_delete"):  # Assuming "ui_delete" is the action name for "P"
		#delete_item()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func delete_item():
	for slot in inv.slots:
		if slot.item:
			inv.remove_item(slot.item)
			StageManager.increment_coin_count(1)  # Delegate coin count update to StageManager
			return
	print("No items to delete")
