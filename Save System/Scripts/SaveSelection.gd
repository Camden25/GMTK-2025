extends Control


func _ready() -> void:
	SaveSystem.reset_player_data()
	SaveSystem.current_save = 0


func _on_back_button_pressed() -> void:
	get_parent().call("swap_active_menu", "main_menu")
