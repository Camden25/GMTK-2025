extends Task

func do_task() -> void:
	# Add a minigame or animation here
	print("Fixing wires...")
	await get_tree().create_timer(2.0).timeout  # Simulate delay
	complete_task()
