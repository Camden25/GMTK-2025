extends Control

var menu_open = false

@onready var scene_manager = get_tree().get_nodes_in_group("Scene Manager")[0]

func _process(_delta):
	menu_open = visible
	if menu_open == false:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused = true
			visible = true
	if menu_open == true:
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			get_tree().paused = false

func _on_resume_button_pressed():
	if menu_open == true:
		visible = false
		get_tree().paused = false

func _on_quit_button_pressed():
	get_tree().paused = false
	SaveSystem.save_file()
	scene_manager.swap_scene(scene_manager.menu_manager_scene)
