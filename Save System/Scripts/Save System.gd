extends Node

@export var current_save: int

var directory_location = "user://saves/"
var save_folder = "save_"
var file_extention = ".res"

func verify_save(file_save):
	if not file_save is SaveData:
		return false
	
	return true

func save_file():
	var new_save = SaveData.new()
	
	new_save.playtime = CurrentSaveData.playtime
	new_save.spawn_location = CurrentSaveData.spawn_location
	new_save.location_name = CurrentSaveData.location_name
	
	if not DirAccess.dir_exists_absolute(directory_location):
		DirAccess.make_dir_recursive_absolute(directory_location)
	
# warning-ignore:return_value_discarded
	ResourceSaver.save(new_save, directory_location + save_folder + str(current_save) + file_extention)

func load_file():
	if not FileAccess.file_exists(directory_location + save_folder + str(current_save) + file_extention):
		return false
	
	var file_save = load(directory_location + save_folder + str(current_save) + file_extention)
	
	if not verify_save(file_save):
		print("couldn't verify save file: " + str(current_save))
		return false
	
	set_player_data(file_save)
	
	return true

func reset_player_data():
	var blank_save = SaveData.new()
	
	set_player_data(blank_save)

func set_player_data(file_save):
	CurrentSaveData.playtime = file_save.playtime
	CurrentSaveData.spawn_location = file_save.spawn_location
	CurrentSaveData.location_name = file_save.location_name

func delete_file():
	if FileAccess.file_exists(directory_location + save_folder + str(current_save) + file_extention):
		DirAccess.remove_absolute(directory_location + save_folder + str(current_save) + file_extention)

func get_data_from_file(number):
	if not FileAccess.file_exists(directory_location + save_folder + str(number) + file_extention):
		print("directory doesn't exist: " + str(number))
		return false
	
	var file_save = load(directory_location + save_folder + str(number) + file_extention)
	
	if not verify_save(file_save):
		print("couldn't verify save file: " + str(number))
		return false
	
	return [file_save.playtime, file_save.location_name]
