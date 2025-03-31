extends CanvasModulate

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day: int, hour: int, minute: int)

@export var gradient_texture: GradientTexture1D
@export var INGAME_SPEED = 20.0

var INITIAL_HOUR = StageManager.hour:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR
		time += INGAME_TO_REAL_MINUTE_DURATION * StageManager.minute
		time += INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_DAY * StageManager.day

var time: float = 0.0
var past_minute: int = -1
@export var node_to_free: NodePath
var node_freed: bool = false

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * StageManager.hour
	time += INGAME_TO_REAL_MINUTE_DURATION * StageManager.minute
	time += INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_DAY * StageManager.day

func _process(delta: float) -> void:
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED

	var value = (sin(time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)

	_recalculate_time()
	_check_free_node()

func _recalculate_time() -> void:
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	var day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)

	StageManager.day = day
	StageManager.hour = hour
	StageManager.minute = minute

	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)

func _check_free_node() -> void:
	if StageManager.hour == 0 and StageManager.minute == 0:
		print("boo")
