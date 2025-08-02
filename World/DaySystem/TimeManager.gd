extends Node
class_name TimeManager

@export var time_speed := 1.0  ## In-game minute per second
@export var day_manager: DayManager
@export var game_event_manager: GameEventManager
var current_time_minutes: float = 0  # 0 to 1440
var formatted_time: String

var triggered_events: Array[Event]

func _ready() -> void:
	reset_time()
	set_process(true)

func reset_time() -> void:
	current_time_minutes = 0
	triggered_events.clear()

func _process(delta: float) -> void:
	current_time_minutes += delta * time_speed
	if current_time_minutes >= 1440:
		day_manager.next_day()
		return
	
	var day: Day = day_manager.current_day
	for scheduled_time: int in day.scheduled_events:
		if current_time_minutes >= scheduled_time:
			var event: Event = day.scheduled_events[scheduled_time]
			if event.trigger_function:
				if event.trigger_values:
					game_event_manager.call(event.trigger_function, event.trigger_values)
			triggered_events.append(scheduled_time)
	
	formatted_time = format_time(int(current_time_minutes))

func format_time(minutes: int) -> String:
	var hrs: int = int(minutes / 60)
	var mins: int = int(minutes) % 60
	return "%02d:%02d" % [hrs, mins]
