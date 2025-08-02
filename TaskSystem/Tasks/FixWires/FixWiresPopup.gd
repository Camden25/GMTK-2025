extends Control

@export var task: Task

@onready var wires := $WireContainer.get_children()

func _ready() -> void:
	for wire in wires:
		wire.connect("wire_connected", Callable(self, "_on_wire_connected"))

func _on_wire_connected() -> void:
	if all_wires_connected():
		task.succeeded_task()

func all_wires_connected() -> bool:
	for wire in wires:
		if wire.end_handle.monitoring:
			return false
	return true
