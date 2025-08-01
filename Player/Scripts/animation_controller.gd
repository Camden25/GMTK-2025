extends Node

@export var animation_tree_path: NodePath
@onready var animation_tree: AnimationTree = get_node(animation_tree_path)
@onready var animation_playback: AnimationNodeStateMachinePlayback = get_node(animation_tree_path)["parameters/playback"]

@export var state_determination_path: NodePath
@onready var state_determination: StateDetermination = get_node(state_determination_path)

@onready var player_states := StateDetermination.PlayerState

var prev_state: StateDetermination.PlayerState


func _process(_delta: float) -> void:
	match state_determination.current_player_state:
		player_states.IDLE:
			animation_playback.travel("Idle")
		player_states.WALK:
			animation_tree.set("parameters/Walk/blend_position", sign(state_determination.player.velocity.x))
			animation_playback.travel("Walk")
