extends PlatformerController2D
class_name Player

var disguised: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("hide"):
		if disguised == false:
			$StateDetermination.current_player_state = $StateDetermination.PlayerState.HIDE
			disguised = true
			can_move = false
		else:
			$StateDetermination.current_player_state = $StateDetermination.PlayerState.UNHIDE
