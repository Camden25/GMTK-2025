extends Node

var current_scene

@onready var menu_manager_scene = preload("res://Menus/Scenes/MenuManager.tscn")

func _ready():
	var menu_manager_instance = menu_manager_scene.instantiate()
	add_child(menu_manager_instance)
	current_scene = menu_manager_instance

func _process(delta):
	if SaveSystem.current_save != 0 and SaveSystem.current_save != null:
		CurrentSaveData.playtime += delta

func swap_scene(new_scene):
	var new_scene_instance = new_scene.instantiate()
	$SceneTransitions/AnimationPlayer.play("FadeToBlack")
	await $SceneTransitions/AnimationPlayer.animation_finished
	remove_child(current_scene)
	call_deferred("add_child", new_scene_instance)
	await new_scene_instance.tree_entered
	$SceneTransitions/AnimationPlayer.play("FadeFromBlack")
	current_scene = new_scene_instance
