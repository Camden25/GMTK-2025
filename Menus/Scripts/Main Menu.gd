extends Control

func _on_start_button_pressed():
	get_parent().call("swap_active_menu", "saves_menu")

func _on_settings_button_pressed():
	get_parent().call("swap_active_menu", "settings_menu")

func _on_quit_button_pressed():
	get_parent().call("swap_active_menu", "quit_menu")
