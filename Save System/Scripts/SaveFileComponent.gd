extends Panel

@export var number = 0

@onready var scene_manager = get_tree().get_nodes_in_group("Scene Manager")[0]

func _ready():
	$"SaveNumber".text = (str(number))
	if str(SaveSystem.get_data_from_file(number)) != "false":
		$"NewFileText".visible = false
		@warning_ignore("integer_division")
		$FileInfo/Location.text = str(SaveSystem.get_data_from_file(number)[1])
		$"FileInfo/Playtime".text = str(int(SaveSystem.get_data_from_file(number)[0])/60) + " Minutes"
		$"FileInfo".visible = true
	if str(SaveSystem.get_data_from_file(number)) == "false":
		$"FileInfo".visible = false
		$"NewFileText".visible = true

func _on_play_button_pressed():
	SaveSystem.current_save = number
	
	if SaveSystem.load_file() == false:
		SaveSystem.save_file()
	SaveSystem.load_file()
	scene_manager.swap_scene(CurrentSaveData.spawn_location)

func _on_delete_button_pressed():
	SaveSystem.current_save = number
	
	SaveSystem.delete_file()
	
	$"FileInfo".visible = false
	$"NewFileText".visible = true
