extends Node
class_name TaskManager

var all_tasks: Array[Task] = []
var active_tasks: Array[Task] = []

func _ready() -> void:
	find_all_tasks()

func find_all_tasks() -> void:
	all_tasks.clear()
	var task_nodes: Array[Node] = get_tree().get_nodes_in_group("Task")
	for task_node in task_nodes:
		if task_node is Task:
			var task: Task = task_node
			task.set_active(false)
			all_tasks.append(task)

func load_tasks(day: Day) -> void:
	clear_active_tasks()
	
	# Activate normal tasks
	for task_name: String in day.normal_tasks:
		print(task_name)
		var task: Task = find_task_by_name(task_name)
		if task:
			task.set_active(true)
			active_tasks.append(task)
	
	# Activate emergency tasks
	var emergency_candidates: Array[Task] = all_tasks.filter(func(t: Task) -> bool: return not t.active)
	for i in range(min(day.emergency_tasks_count, emergency_candidates.size())):
		var task: Task = emergency_candidates[i]
		task.set_active(true)
		active_tasks.append(task)

func find_task_by_name(task_name: String) -> Task:
	print(task_name)
	for task: Task in all_tasks:
		if task.task_name == task_name:
			return task
	return null

func clear_active_tasks() -> void:
	for task: Task in active_tasks:
		if is_instance_valid(task):
			task.set_active(false)
	active_tasks.clear()

func check_all_tasks_complete() -> bool:
	for task: Task in active_tasks:
		if not task.completed:
			return false
	return true
