extends Node
class_name StateDetermination

@export var player_path: NodePath
@onready var player: Player = get_node(player_path)

@export var animation_controller: PlayerAnimationController

enum PlayerState {
	IDLE,
	WALK,
	JUMP,
	FALL,
	HIDE,
	UNHIDE
}
var current_player_state: PlayerState = PlayerState.IDLE


func _process(_delta: float) -> void:
	if current_player_state != PlayerState.HIDE and current_player_state != PlayerState.UNHIDE:
		if player.velocity.y < 0:
			current_player_state = PlayerState.JUMP
		elif player.velocity.y >= 0.1:
			current_player_state = PlayerState.FALL
		elif abs(player.velocity.x) >= 0.1:
			current_player_state = PlayerState.WALK
		else:
			current_player_state = PlayerState.IDLE
