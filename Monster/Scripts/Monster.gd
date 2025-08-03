extends CharacterBody2D

@export var animation_tree: AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@onready var player: Player = get_tree().get_first_node_in_group("Player")

enum MonsterState {
	IDLE,
	CHASE
}
var current_monster_state: MonsterState = MonsterState.IDLE

func _process(_delta: float) -> void:
	if abs(velocity.x) >= 0.1:
		animation_playback.travel("Walk")
	else:
		animation_playback.travel("Idle")
