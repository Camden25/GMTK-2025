extends Node
class_name DayManager

@export var days: Array[Day]
var current_day: Day
var current_day_index: int = 0

@export var task_manager: TaskManager
@export var time_manager: TimeManager

func _ready() -> void:
	load_day(current_day_index)

func load_day(index: int) -> void:
	if index >= 0 and index < days.size():
		current_day = days[index]
		task_manager.load_tasks(current_day)
		time_manager.reset_time()
	else:
		print("No more days. Game Over or End Scene.")

func next_day() -> void:
	current_day_index += 1
	load_day(current_day_index)
