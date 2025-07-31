extends CanvasLayer

@export var health_bar_size = 400

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var main_character = get_tree().get_nodes_in_group("Main Character")[0]
@onready var enemy = get_tree().get_nodes_in_group("Boss")[0]

func _process(_delta):
	set_player_health_bar()
	set_main_character_health_bar()
	set_enemy_health_bar()

func set_player_health_bar():
	$"Health Bar".offset = player.global_position - Vector2(health_bar_size/2, 200)
	$"Health Bar/Background".size.x = health_bar_size + 10
	$"Health Bar/Midground".size.x = health_bar_size
	$"Health Bar/Foreground".size.x = health_bar_size * (float(player.health)/float(player.max_health))
	if main_character.health <= 0 or player.health <= 0:
		$"Health Bar".visible = false

func set_main_character_health_bar():
	$"Main Character Health Bar".offset = main_character.global_position - Vector2(health_bar_size/2, 400)
	$"Main Character Health Bar/Background".size.x = health_bar_size + 10
	$"Main Character Health Bar/Midground".size.x = health_bar_size
	$"Main Character Health Bar/Foreground".size.x = health_bar_size * (float(main_character.health)/float(main_character.max_health))
	if main_character.health <= 0 or player.health <= 0:
		$"Main Character Health Bar".visible = false

func set_enemy_health_bar():
	$"Enemy Health Bar".offset = enemy.global_position - Vector2(health_bar_size/2, 400)
	$"Enemy Health Bar/Background".size.x = health_bar_size + 10
	$"Enemy Health Bar/Midground".size.x = health_bar_size
	$"Enemy Health Bar/Foreground".size.x = health_bar_size * (float(enemy.health)/float(enemy.max_health))
	if enemy.health <= 0 or main_character.health <= 0 or player.health <= 0:
		$"Enemy Health Bar".visible = false
