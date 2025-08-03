extends Area2D
class_name TaskLight

var light_on: bool = false

var neighbors: Array[TaskLight]

var pos: Vector2

func toggle() -> void:
	light_on = not light_on
	$LightOn.visible = light_on
	$LightOff.visible = not light_on

func set_neighbors() -> void:
	check_pos(pos + Vector2(-1, 0))
	check_pos(pos + Vector2(1, 0))
	check_pos(pos + Vector2(0, -1))
	check_pos(pos + Vector2(0, 1))

func check_pos(test_pos: Vector2) -> void:
	if test_pos.x < 0:
		return
	if test_pos.x > 4:
		return
	if test_pos.y < 0:
		return
	if test_pos.y > 4:
		return
	set_light_from_pos(test_pos)

func set_light_from_pos(test_pos: Vector2) -> void:
	neighbors.append(get_parent().lights_popup.lights_2d[int(test_pos.x)][int(test_pos.y)])

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle()
		for light: TaskLight in neighbors:
			light.toggle()
