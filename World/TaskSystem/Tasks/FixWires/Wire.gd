extends Node2D

@export var line: Line2D
@export var end_handle: Node
@export var start_point: Node2D
@export var correct_target: Area2D

var wire_color: Color
var dragging: bool = false

signal wire_connected

func _ready() -> void:
	randomize()
	set_end_handle_position()
	set_wire_color()
	line.clear_points()
	line.add_point(start_point.position)
	line.add_point(end_handle.position)
	
	end_handle.connect("input_event", Callable(self, "_on_end_handle_input_event"))

func _process(_delta: float) -> void:
	if dragging:
		var mouse_pos: Vector2 = get_global_mouse_position()
		end_handle.global_position = mouse_pos
		line.set_point_position(1, end_handle.position)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			print("Mouse released")
			if dragging:
				dragging = false
				_check_connection()

func _check_connection() -> void:
	for area in get_tree().get_nodes_in_group("WireTargets"):
		if area.global_position.distance_to(end_handle.global_position) < 20:
			if area == correct_target:
				end_handle.global_position = area.global_position
				line.set_point_position(1, end_handle.position)
				end_handle.monitoring = false
				emit_signal("wire_connected") # optional
			else:
				## reset if wrong
				#end_handle.global_position = start_point.global_position + Vector2(randf_range(-200, 200), randf_range(-300, 50))
				end_handle.global_position = Vector2(randf_range(320, 1600), randf_range(162, 918))
				line.set_point_position(1, end_handle.position)

func set_end_handle_position() -> void:
	#end_handle.position = Vector2(randf_range(-40,40), randf_range(-60, -20))
	end_handle.global_position = Vector2(randf_range(320, 1600), randf_range(162, 918))

func set_wire_color() -> void:
	wire_color = Color.from_hsv(randf_range(0.0,1.0), 0.85, 0.8, 1.0)
	line.default_color = wire_color

func _on_end_handle_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	print("input event")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		dragging = true
