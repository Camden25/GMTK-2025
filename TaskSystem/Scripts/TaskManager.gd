extends Node

@export var required_tasks: int = 3
var total_tasks: int = 0
var tasks_done: int = 0

func _ready() -> void:
	for task in get_tree().get_nodes_in_group("Task"):
		register_task(task)

func register_task(task: Task) -> void:
	task.task_completed.connect(_on_task_completed)
	total_tasks += 1
	print("Task registered: ", task.task_name)

func _on_task_completed(task: Task) -> void:
	tasks_done += 1
	print("Completed: ", task.task_name)
	if tasks_done >= required_tasks:
		print("All tasks complete!")
		# Trigger end-of-day or progression
