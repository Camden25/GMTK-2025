extends Control

@export var task: Task

@onready var light_scene: PackedScene = preload("res://World/TaskSystem/Tasks/LightsOn/Light.tscn")

var lights_2d: Array = [[],[],[],[],[]]
var lights_1d: Array

func _ready() -> void:
	randomize()
	for i in lights_1d:
		i.set_neighbors()
	for i in randi_range(15, 20):
		var random_light: TaskLight = lights_1d.pick_random()
		random_light.toggle()
		for light: TaskLight in random_light.neighbors:
			light.toggle()

func _process(_delta: float) -> void:
	check_all_lights_on()

func check_all_lights_on() -> void:
	for light: TaskLight in lights_1d:
		if light.light_on == false:
			return
	
	task.succeeded_task()

func get_random_unique_numbers(count: int, min_val: int, max_val: int) -> Array:
	var numbers := []
	for i in range(min_val, max_val + 1):
		numbers.append(i)
	numbers.shuffle()
	return numbers.slice(0, count)
