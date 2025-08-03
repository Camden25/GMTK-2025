extends CharacterBody2D
class_name Monster

@export var animation_tree: AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@export var speed_scale: float = 1.0
@onready var chase_speed: float = 47.5 * speed_scale

@export var chase_music: AudioStream
@export var normal_music: AudioStream

@onready var scene_manager: SceneManager = get_tree().get_first_node_in_group("SceneManager")
@onready var player: Player = get_tree().get_first_node_in_group("Player")
var sees_player: bool = false

var patrol_target: int

enum MonsterState {
	IDLE,
	PATROL,
	CHASE
}
var current_monster_state: MonsterState = MonsterState.IDLE

func _ready() -> void:
	enter_idle_state()

func _process(_delta: float) -> void:
	can_see_player()
	
	if velocity.x != 0:
		animation_tree.set("parameters/Walk/blend_position", sign(velocity.x))
	
	match current_monster_state:
		MonsterState.IDLE:
			if sees_player == true:
				enter_chase_state()
		MonsterState.PATROL:
			if sees_player == true:
				enter_chase_state()
			if abs(global_position.x - patrol_target) <= 50:
				enter_idle_state()
		MonsterState.CHASE:
			if global_position.distance_squared_to(player.global_position) >= 400**2:
				enter_idle_state()
				AudioManager.change_music(normal_music)
			if player.disguised == true:
				enter_idle_state()
				await get_tree().create_timer(0.5).timeout
				AudioManager.change_music(normal_music)

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, 0)
	
	match current_monster_state:
		MonsterState.IDLE:
			velocity.x = 0
		MonsterState.PATROL:
			velocity.x = sign(patrol_target - global_position.x) * 47.5
		MonsterState.CHASE:
			velocity.x = sign(player.global_position.x - global_position.x) * chase_speed
	
	move_and_slide()

func can_see_player() -> void:
	var overlapping_bodies: Array = $PlayerDetection.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		if overlapping_bodies[0] is Player:
			player = overlapping_bodies[0]
			if player.disguised == false:
				sees_player = true
				return
	sees_player = false

func enter_idle_state() -> void:
	current_monster_state = MonsterState.IDLE
	animation_playback.travel("Idle")
	$AnimationPlayer.speed_scale = 1.0
	$Timer.start(randf_range(0.2, 1.2))

func enter_patrol_state() -> void:
	current_monster_state = MonsterState.PATROL
	animation_playback.travel("Walk")
	$AnimationPlayer.speed_scale = 1.0
	patrol_target = randi_range(-900, 900)

func enter_chase_state() -> void:
	current_monster_state = MonsterState.CHASE
	animation_playback.travel("Walk")
	$AnimationPlayer.speed_scale = speed_scale
	AudioManager.sound_effect("VillainHit.tres")
	AudioManager.change_music(chase_music)

func _on_timer_timeout() -> void:
	if current_monster_state == MonsterState.IDLE:
		enter_patrol_state()

func make_walk_sfx() -> void:
	AudioManager.sound_effect("MonsterWalk.tres", 0-abs(global_position.x - player.global_position.x)*0.05)

func _on_hitbox_area_entered(area: Area2D) -> void:
	scene_manager.swap_scene(load("res://Menus/Scenes/MenuManager.tscn"))
