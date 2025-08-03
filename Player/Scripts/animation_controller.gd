extends Node
class_name PlayerAnimationController

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
			if animation_tree.get("parameters/Walk/blend_position") < 0:
				get_parent().get_node("Sprite2D").flip_h = true
		player_states.WALK:
			if state_determination.player.velocity.x != 0:
				animation_tree.set("parameters/Walk/blend_position", sign(state_determination.player.velocity.x))
			animation_playback.travel("Walk")
		player_states.HIDE:
			animation_playback.travel("Hide")
			if animation_tree.get("parameters/Walk/blend_position") < 0:
				get_parent().get_node("Sprite2D").flip_h = true
		player_states.UNHIDE:
			get_node(animation_tree.anim_player).play("unhide")
			animation_playback.travel("Unhide")
			if animation_tree.get("parameters/Walk/blend_position") < 0:
				get_parent().get_node("Sprite2D").flip_h = true
			await get_node(animation_tree.anim_player).animation_finished
			state_determination.current_player_state = state_determination.PlayerState.IDLE
			state_determination.player.disguised = false
			state_determination.player.can_move = true
