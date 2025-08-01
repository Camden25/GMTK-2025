extends Node
class_name StateDetermination

@export var player_path: NodePath
@onready var player: Player = get_node(player_path)

enum PlayerState {
	IDLE,
	WALK,
	JUMP,
	FALL
}
var current_player_state: PlayerState = PlayerState.IDLE


func _process(_delta: float) -> void:
	if player.velocity.y < 0:
		current_player_state = PlayerState.JUMP
	elif player.velocity.y >= 0.1:
		current_player_state = PlayerState.FALL
	elif abs(player.velocity.x) >= 0.1:
		current_player_state = PlayerState.WALK
	else:
		current_player_state = PlayerState.IDLE
