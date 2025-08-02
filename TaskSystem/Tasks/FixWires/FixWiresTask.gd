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
