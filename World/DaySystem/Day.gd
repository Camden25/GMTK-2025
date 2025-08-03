extends Resource
class_name Day

@export var normal_tasks: Array[String] ## Task names
@export var emergency_tasks_count: int
@export var events: Array[Event]

var scheduled_events: Dictionary

func _ready() -> void:
	for event: Event in events:
		scheduled_events.set(event.time, event)
