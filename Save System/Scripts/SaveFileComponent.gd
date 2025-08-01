extends Panel

@export var number: int = 0

@onready var scene_manager: SceneManager = get_tree().get_nodes_in_group("Scene Manager")[0]


func _ready() -> void:
	$"SaveNumber".text = (str(number))
	if str(SaveSystem.get_data_from_file(number)) != "false":
		$"NewFileText".visible = false
		@warning_ignore("integer_division")
		$FileInfo/Location.text = str(SaveSystem.get_data_from_file(number)[1])
		@warning_ignore("integer_division")
		$"FileInfo/Playtime".text = str(int(SaveSystem.get_data_from_file(number)[0])/60) + " Minutes"
		$"FileInfo".visible = true
	if str(SaveSystem.get_data_from_file(number)) == "false":
		$"FileInfo".visible = false
		$"NewFileText".visible = true


func _on_play_button_pressed() -> void:
	SaveSystem.current_save = number

	if SaveSystem.load_file() == false:
		SaveSystem.save_file()
	SaveSystem.load_file()
	scene_manager.swap_scene(CurrentSaveData.spawn_location)


func _on_delete_button_pressed() -> void:
	SaveSystem.current_save = number

	SaveSystem.delete_file()

	$"FileInfo".visible = false
	$"NewFileText".visible = true
