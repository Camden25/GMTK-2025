extends Node
class_name GameEventManager
## Controls Game Events

@export var lights: Node2D

func disable_lights() -> void:
	print("disabling lights")
	var child_lights: Array = lights.get_children()
	child_lights.shuffle()
	for light: PointLight2D in child_lights:
		light.get_node("AnimationPlayer").play("Flicker")
		await get_tree().create_timer(randf_range(0.15, 0.35)).timeout

func summon_monster() -> void:
	var monster_instance: Monster = preload("res://Monster/Scenes/Monster.tscn").instantiate()
	monster_instance.global_position = Vector2(-1080, 65)
	get_parent().add_child(monster_instance)
