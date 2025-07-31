extends Node

func _process(_delta):
	for i in get_node("SFX").get_children():
		if i.playing == false:
			i.queue_free()

func clear_sfx():
	for i in get_node("SFX").get_children():
		i.queue_free()

func sound_effect(stream_name):
	var stream_player_instance = AudioStreamPlayer.new()
	stream_player_instance.stream = load("res://Audio/SoundEffects/" + stream_name)
	stream_player_instance.bus = "SFX"
	get_node("SFX").add_child(stream_player_instance)
	stream_player_instance.play()

func change_music(new_track: AudioStream):
	if $Music/Main.stream != new_track:
		if $Music/Main.stream != null:
			$AudioTransitions.play("FadeOut")
			await $AudioTransitions.animation_finished
		$Music/Main.stream = new_track
		$AudioTransitions.play("FadeIn")
