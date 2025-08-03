extends Task

@onready var popup: CanvasLayer = $PopupUI

func do_task() -> void:
	popup.visible = true
	get_tree().paused = true

func succeeded_task() -> void:
	popup.visible = false
	get_tree().paused = false
	complete_task()

func failed_task() -> void:
	popup.visible = false
	get_tree().paused = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and popup.visible == true:
		failed_task()
