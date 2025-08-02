extends Area2D

@export var node_trigger: Node
@export var node_interact_function: String = "interact"
@export var interaction_text: String = ""

var disabled: bool = false

@onready var label: Label = $Label

func _ready() -> void:
	label.visible = false
	label.text = interaction_text + " (" + OS.get_keycode_string(InputMap.action_get_events("interact")[0].physical_keycode) + ")"

func _process(_delta: float) -> void:
	if get_overlapping_areas().size() > 0 and disabled == false:
		label.visible = true
		if Input.is_action_just_pressed("interact"):
			interaction()
	else:
		label.visible = false

func interaction() -> void:
	node_trigger.call(node_interact_function)
