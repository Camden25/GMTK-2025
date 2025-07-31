extends Control

func _on_back_button_pressed():
	get_parent().call("swap_active_menu", "settings_menu")
