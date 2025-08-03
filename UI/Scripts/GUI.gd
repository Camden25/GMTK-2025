extends CanvasLayer

@export var player: Player
@export var time_manager: TimeManager
@export var day_manager: DayManager
@export var task_manager: TaskManager

func _process(_delta: float) -> void:
	update_day()
	update_time()
	update_tasks()

func update_day() -> void:
	$"Current Day".text = "Day " + str(day_manager.current_day_index + 1)

func update_time() -> void:
	$"Current Time".text = time_manager.formatted_time

func update_tasks() -> void:
	for task: Task in task_manager.active_tasks:
		add_task(task)
	
	for label: Label in $Tasks.get_children():
		remove_label(label)

func remove_label(label) -> void:
	for task: Task in task_manager.active_tasks:
		if label.text == task.task_name:
			return
	label.queue_free()

func add_task(task: Task) -> void:
	for child: Label in get_node("Tasks").get_children():
		if child.text == task.task_name:
			return
	
	var label: Label = Label.new()
	label.text = task.task_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.add_theme_font_size_override("font_size", 48)
	get_node("Tasks").add_child(label)
