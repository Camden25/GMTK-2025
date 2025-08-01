extends Area2D

@export var node_trigger_path: NodePath
@export var node_interact_function: String = "interact"

func _ready() -> void:
	$Label.visible = false
	$Label.text = OS.get_keycode_string(InputMap.action_get_events("interact")[0].physical_keycode)

func _process(_delta: float) -> void:
	if get_overlapping_areas().size() > 0:
		$Label.visible = true
		if Input.is_action_just_pressed("interact"):
			interaction()

func interaction() -> void:
	get_node(node_trigger_path).call(node_interact_function)
