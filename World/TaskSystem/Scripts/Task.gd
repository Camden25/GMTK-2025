extends Node2D
class_name Task

signal task_completed(task: Task)

@export var task_name: String = "Unnamed Task"
var active: bool = false
var completed: bool = false

func _ready() -> void:
	set_active(false)
	add_to_group("Task")

func interact() -> void:
	if completed or not active:
		return
	do_task()

func do_task() -> void:
	# Override this in child classes for custom behavior
	complete_task()

func set_active(state: bool) -> void:
	active = state
	$Interactable.disabled = not state

func complete_task() -> void:
	completed = true
	task_completed.emit(self)
	$Interactable.disabled = true
