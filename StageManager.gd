extends CanvasLayer

const MAIN = preload("res://scenes/World.tscn")
const TAVERNE = preload("res://scenes/taverne.tscn")
const SHOP = preload("res://Shop/ShopRoom.tscn")
const HOUSE1 = preload("res://scenes/House1.tscn")
const SPAWN = preload("res://houses/Spawn.tscn")
const HUT0 = preload("res://houses/SmallHouseInterior0.tscn")
const HUT1 = preload("res://houses/SmallHouseInterior1.tscn")
const ALCHEMIST = preload("res://scenes/Alchemist.tscn")
const CREEP = preload("res://scenes/CreepHouse.tscn")
const MONEST = preload("res://scenes/Monestary.tscn")
const CAVE = preload("res://scenes/cave.tscn")
const CASTLE = preload("res://houses/InsideCastle.tscn")
const CASTLEUP = preload("res://houses/castle.tscn")

var scenes = {
	"MAIN": MAIN,
	"TAVERNE": TAVERNE,
	"SHOP": SHOP,
	"HOUSE1": HOUSE1,
	"SPAWN": SPAWN,
	"HUT0": HUT0,
	"HUT1": HUT1,
	"ALCHEMIST": ALCHEMIST,
	"CREEP": CREEP,
	"MONEST": MONEST,
	"CAVE": CAVE,
	"CASTLE": CASTLE,
	"CASTLEUP": CASTLEUP,
}

@onready var coin_label: Label = $CoinLabel
@onready var coin_icon = $CoinIcon
@onready var cat = $cat

# Quests
@onready var quests = $Quests
@onready var quests_label = $Quests/questsLabel
@onready var rat = $Quests/rat
@onready var legume = $Quests/legume
@onready var four = $Quests/four
@onready var statue = $Quests/statue
@onready var bougies = $Quests/bougies
@onready var heure = $Quests/heure
@onready var cave = $Quests/cave

# States
var paintingCount: int = 0
var met_narrator: String = ""
var started_game: String = ""

var talked_lucifer: String = ""
var talked_milo: String = ""
var talked_chaussette: String = ""
var talked_rocket: String = ""
var talked_moustache: String = ""
var talked_felix: String = ""
var talked_bobby: String = ""

var minute: int = 30
var hour: int = 2
var day: int = 0

# Trivia
var t_status0: String = ""
var t_status1: String = ""
var t_status2: String = ""
var t_status3: String = ""
var t_status4: String = ""
var t_status5: String = ""

var egg_status: String = ""
var cave_status: String = ""
var clock_status: String = ""
var symbol_status: String = ""
var candles_lit: int = 0
var statue_status: String = ""
var forge_status: String = ""
var rat_status: String = ""
var plant_status: String = ""
var plants: int = 0
var coin_count: int = 0
var opened_chests: Dictionary = {}
var collected_items: Dictionary = {}

# Translations
func updateUI():
	$Loading.text = tr("LOADING")
	$Quests/questsLabel.text = tr("QUESTS")
	$Quests/rat.text = tr("RAT")
	$Quests/legume.text = tr("LEGUME")
	$Quests/four.text = tr("FOUR")
	$Quests/statue.text = tr("STATUE")
	$Quests/bougies.text = tr("BOUGIES")
	$Quests/heure.text = tr("HEURE")
	$Quests/cave.text = tr("CAVE")
	$EscapeMenu/Options2/Label.text = tr("OPTIONS")
	$EscapeMenu/Options2/Label2.text = tr("GENERAL")
	$EscapeMenu/Options2/Label3.text = tr("SFX")
	$EscapeMenu/Options2/Quit3.text = tr("QUIT")
	$EscapeMenu/Options2/Label4.text = tr("MUSIC")
	$"EscapeMenu/Options2/Sure?/Label".text = tr("QUITW")
	$"EscapeMenu/Options2/Sure?/Back".text = tr("BACK")
	$"EscapeMenu/Options2/Sure?/Quit".text = tr("QUIT1")
	$EscapeMenu/Options2/Label5.text = tr("C")
	$EscapeMenu/Options2/Label6.text = tr("M")
	$EscapeMenu/Options2/Label7.text = tr("F")
	$EscapeMenu/Options2/Label8.text = tr("P")
	$EscapeMenu/Options2/Label9.text = tr("SPACE")
	$EscapeMenu/Options2/Controles.text = tr("CONTROLES")
func _ready():
	get_node("ColorRect").hide()
	get_node("Loading").hide()
	get_node("cat").hide()
	update_coin_label()
	coin_icon.play("idle")
	quests.visible = false
	rat.visible = false
	legume.visible = false
	four.visible = false
	statue.visible = false
	bougies.visible = false
	heure.visible = false
	cat.visible = false
	cave.visible = false
	updateUI()

func _physics_process(_delta):
	if coin_count == 0:
		coin_icon.visible = false
		coin_label.visible = false
	else:
		coin_icon.visible = true
		coin_label.visible = true

func changeStage(stage_key: String, x: int, y: int):
	if stage_key in scenes:
		var stage_path = scenes[stage_key]
		get_node("ColorRect").show()
		get_node("Loading").show()
		get_node("cat").show()
		play_random_cat_animation()
		get_node("anim").play("TransIn")
		await get_node("anim").animation_finished

		var stage = stage_path.instantiate()
		get_tree().root.get_child(2).free()
		get_tree().root.add_child(stage)
		stage.get_node("Player").position = Vector2(x, y)
		stage.get_node("Player").visible = true

		get_node("anim").play("TransOut")
		await get_node("anim").animation_finished
		get_node("ColorRect").hide()
	else:
		print("Invalid stage key: %s" % stage_key)

func update_coin_label():
	coin_label.text = "x %d" % coin_count

func increment_coin_count(amount: int):
	coin_count += amount
	coin_icon.play("shine")
	await get_tree().create_timer(1).timeout
	coin_icon.play("idle")
	update_coin_label()

func subtract_coins(amount: int) -> bool:
	if coin_count >= amount:
		coin_count -= amount
		update_coin_label()
		return true
	else:
		print("Not enough coins to subtract", amount)
		return false

# Chest tracking functions
func is_chest_opened(chest_id: String) -> bool:
	return opened_chests.has(chest_id)

func mark_chest_as_opened(chest_id: String):
	opened_chests[chest_id] = true

# Item tracking functions
func is_item_collected(item_id: String) -> bool:
	return collected_items.has(item_id)

func mark_item_as_collected(item_id: String):
	collected_items[item_id] = true

# Function to add 5 coins (example: when capturing a rat)
func add_coins_on_rat_capture():
	increment_coin_count(5)

func pick_random_1_or_2() -> int:
	randomize()  # Initialize the random number generator
	return randi() % 2 + 1

func play_random_cat_animation():
	var random_number = pick_random_1_or_2()
	if random_number == 1:
		cat.play("sleepy")
	else:
		cat.play("awake")

func plants_owned(amounts: int):
	plants += amounts
	plant_status = "has"
	print(plants)

func _on_language_2_language_changed():
	updateUI()
