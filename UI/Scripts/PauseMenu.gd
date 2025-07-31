extends Control

var menu_open = false

onready var parent = get_tree().get_nodes_in_group("Parent")[0]
onready var scene_manager = get_tree().get_nodes_in_group("Scene Manager")[0]

func _process(_delta):
	menu_open = visible
	if menu_open == false and parent.shop_open == false:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused = true
			visible = true
	if menu_open == true:
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			get_tree().paused = false

func _on_ResumeButton_pressed():
	if menu_open == true:
		visible = false
		get_tree().paused = false

func _on_QuitButton_pressed():
	SaveSystem.save_file()
	scene_manager.swap_scene(load("res://Menus/Scenes/SaveSelection.tscn"))
