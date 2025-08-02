extends Resource
class_name Day

@export var normal_tasks: Array[String] ## Task names
@export var emergency_tasks_count: int
@export var scheduled_events: Dictionary[int, Event] # { (0-1440): Event }
