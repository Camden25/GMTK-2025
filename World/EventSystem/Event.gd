extends Resource
class_name Event
## Game event that triggers a function in GameEventManager

@export var name: String
@export var trigger_function: String ## GameEventManager function name
@export var trigger_values: Array
@export var time: int
