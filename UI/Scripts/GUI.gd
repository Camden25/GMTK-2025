extends CanvasLayer

@export var player: Player
@export var time_manager: TimeManager
@export var day_manager: DayManager
@export var task_manager: TaskManager

func _process(delta: float) -> void:
	update_day()
	update_time()

func update_day() -> void:
	$"Current Day".text = "Day " + str(day_manager.current_day_index + 1)

func update_time() -> void:
	$"Current Time".text = time_manager.formatted_time
