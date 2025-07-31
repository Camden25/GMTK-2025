extends Control

func _on_yes_button_pressed():
	get_tree().quit()

func _on_no_button_pressed():
	get_parent().call("swap_active_menu", "main_menu")
