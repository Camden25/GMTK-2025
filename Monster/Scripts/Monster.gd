extends CharacterBody2D

@export var animation_tree: AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@export var speed_scale: float
@onready var move_speed: float = 47.5 * speed_scale

@onready var player: Player = get_tree().get_first_node_in_group("Player")

enum MonsterState {
	IDLE,
	PATROL,
	CHASE
}
var current_monster_state: MonsterState = MonsterState.IDLE

func _process(_delta: float) -> void:
	if abs(velocity.x) >= 0.1:
		animation_playback.travel("Walk")
	else:
		animation_playback.travel("Idle")
	
	match current_monster_state:
		MonsterState.IDLE:
			animation_playback.travel("Idle")
			$AnimationPlayer.speed_scale = 1.0
		MonsterState.PATROL:
			animation_playback.travel("Walk")
			$AnimationPlayer.speed_scale = 1.0
		MonsterState.CHASE:
			animation_playback.travel("Walk")
			$AnimationPlayer.speed_scale = speed_scale
