extends Area2D
class_name Task

signal task_completed(task: Task)

@export var task_name: String = "Unnamed Task"
var is_completed: bool = false

func _ready() -> void:
	add_to_group("Task")

func interact() -> void:
	if is_completed:
		return
	do_task()

func do_task() -> void:
	# Override this in child classes for custom behavior
	complete_task()

func complete_task() -> void:
	is_completed = true
	task_completed.emit(self)
