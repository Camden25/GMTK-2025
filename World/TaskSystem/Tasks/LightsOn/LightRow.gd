extends Node2D

@export var row_number: int
@export var lights_popup: Control

@onready var light_scene: PackedScene = preload("res://World/TaskSystem/Tasks/LightsOn/Light.tscn")

var row_lights: Array[TaskLight]

func _ready() -> void:
	spawn_lights()

func spawn_lights() -> void:
	for i: int in range(5):
		var light_instance: TaskLight = light_scene.instantiate()
		light_instance.position.x = i*156
		light_instance.pos = Vector2(row_number, i)
		add_child(light_instance)
		row_lights.append(light_instance)
		lights_popup.lights_1d.append(light_instance)
	
	lights_popup.lights_2d[row_number] = row_lights
