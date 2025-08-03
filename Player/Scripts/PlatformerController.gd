extends CharacterBody2D
class_name PlatformerController2D

signal jumped(is_ground_jump: bool)
signal hit_ground()


@export var input_left : String = "move_left"
@export var input_right : String = "move_right"
@export var input_jump : String = "jump"


const DEFAULT_MAX_JUMP_HEIGHT = 150
const DEFAULT_MIN_JUMP_HEIGHT = 60
const DEFAULT_DOUBLE_JUMP_HEIGHT = 100
const DEFAULT_JUMP_DURATION = 0.3

var _max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT
@export var max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT:
	get:
		return _max_jump_height
	set(value):
		_max_jump_height = value

		default_gravity = calculate_gravity(_max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(_max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)


var _min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT
## The minimum jump height (tapping jump).
@export var min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT:
	get:
		return _min_jump_height
	set(value):
		_min_jump_height = value
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)



var _double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT
@export var double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT:
	get:
		return _double_jump_height
	set(value):
		_double_jump_height = value
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)


var _jump_duration: float = DEFAULT_JUMP_DURATION
@export var jump_duration: float = DEFAULT_JUMP_DURATION:
	get:
		return _jump_duration
	set(value):
		_jump_duration = value

		default_gravity = calculate_gravity(max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)

@export var falling_gravity_multiplier: float = 1.5
@export var max_jump_amount: int = 1
@export var max_acceleration: int = 10000
@export var max_horizontal_velocity: int = 150
@export var friction: int = 20
@export var air_friction: int = 5
@export var can_hold_jump : bool = false
@export var coyote_time : float = 0.1
@export var jump_buffer : float = 0.1


# Calcualted automatically
var default_gravity : float
var jump_velocity : float
var double_jump_velocity : float
var release_gravity_multiplier : float


var jumps_left : int
var holding_jump := false

enum JumpType {NONE, GROUND, AIR}
var current_jump_type: JumpType = JumpType.NONE

var _was_on_ground: bool

var acc: Vector2 = Vector2()

var can_move: bool = true


@onready var is_coyote_time_enabled: bool = coyote_time > 0
@onready var is_jump_buffer_enabled: bool = jump_buffer > 0
@onready var coyote_timer: Timer = Timer.new()
@onready var jump_buffer_timer: Timer = Timer.new()


func _init() -> void:
	default_gravity = calculate_gravity(max_jump_height, jump_duration)
	jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
	release_gravity_multiplier = calculate_release_gravity_multiplier(
			jump_velocity, min_jump_height, default_gravity)


func _ready() -> void:
	if is_coyote_time_enabled:
		add_child(coyote_timer)
		coyote_timer.wait_time = coyote_time
		coyote_timer.one_shot = true
	
	if is_jump_buffer_enabled:
		add_child(jump_buffer_timer)
		jump_buffer_timer.wait_time = jump_buffer
		jump_buffer_timer.one_shot = true


func _input(_event: InputEvent) -> void:
	acc.x = 0
	var acc_dir: int = int(Input.is_action_pressed(input_right)) - int(Input.is_action_pressed(input_left))
	acc.x = max_acceleration*acc_dir
	
	if Input.is_action_just_pressed(input_jump):
		holding_jump = true
		start_jump_buffer_timer()
		if (not can_hold_jump and can_ground_jump()) or can_double_jump():
			jump()
	
	if Input.is_action_just_released(input_jump):
		holding_jump = false


func _physics_process(delta: float) -> void:
	if is_coyote_timer_running() or current_jump_type == JumpType.NONE:
		jumps_left = max_jump_amount
	if is_feet_on_ground() and current_jump_type == JumpType.NONE:
		start_coyote_timer()
	
	if not _was_on_ground and is_feet_on_ground():
		current_jump_type = JumpType.NONE
		if is_jump_buffer_timer_running() and not can_hold_jump:
			jump()
		
		hit_ground.emit()
	
	
	if Input.is_action_pressed(input_jump):
		if can_ground_jump() and can_hold_jump:
			jump()
	
	var gravity: float = apply_gravity_multipliers_to(default_gravity)
	acc.y = gravity
	
	if is_feet_on_ground():
		velocity.x *= 1 / (1 + (delta * friction))
	else:
		velocity.x *= 1 / (1 + (delta * air_friction))
	velocity += acc * delta
	
	velocity.x = clamp(velocity.x, -max_horizontal_velocity, max_horizontal_velocity)
	
	if can_move == false:
		velocity.x = 0
		velocity.y = clamp(velocity.y, 0, 100)
	
	_was_on_ground = is_feet_on_ground()
	move_and_slide()


func start_coyote_timer() -> void:
	if is_coyote_time_enabled:
		coyote_timer.start()


func start_jump_buffer_timer() -> void:
	if is_jump_buffer_enabled:
		jump_buffer_timer.start()


func is_coyote_timer_running() -> bool:
	if (is_coyote_time_enabled and not coyote_timer.is_stopped()):
		return true
	
	return false


func is_jump_buffer_timer_running() -> bool:
	if is_jump_buffer_enabled and not jump_buffer_timer.is_stopped():
		return true
	
	return false


func can_ground_jump() -> bool:
	if jumps_left > 0 and current_jump_type == JumpType.NONE:
		return true
	elif is_coyote_timer_running():
		return true
	
	return false


func can_double_jump() -> bool:
	if jumps_left <= 1 and jumps_left == max_jump_amount:
		return false
	
	if jumps_left > 0 and not is_feet_on_ground() and coyote_timer.is_stopped():
		return true
	
	return false


func is_feet_on_ground() -> bool:
	if is_on_floor() and default_gravity >= 0:
		return true
	if is_on_ceiling() and default_gravity <= 0:
		return true
	
	return false


func jump() -> void:
	if can_double_jump():
		double_jump()
	else:
		ground_jump()


## Perform a double jump without checking if the player is able to.
func double_jump() -> void:
	if jumps_left == max_jump_amount:
		jumps_left -= 1
	
	velocity.y = -double_jump_velocity
	current_jump_type = JumpType.AIR
	jumps_left -= 1
	jumped.emit(false)


## Perform a ground jump without checking if the player is able to.
func ground_jump() -> void:
	velocity.y = -jump_velocity
	current_jump_type = JumpType.GROUND
	jumps_left -= 1
	coyote_timer.stop()
	jumped.emit(true)


func apply_gravity_multipliers_to(gravity: float) -> float:
	if velocity.y * sign(default_gravity) > 0: # If we are falling
		gravity *= falling_gravity_multiplier
	
	# if we released jump and are still rising
	elif velocity.y * sign(default_gravity) < 0:
		if not holding_jump:
			if not current_jump_type == JumpType.AIR:
				gravity *= release_gravity_multiplier
	
	
	return gravity


## Calculates the desired gravity from jump height and jump duration.  [br]
## Formula is from [url=https://www.youtube.com/watch?v=hG9SzQxaCm8]this video[/url]
func calculate_gravity(p_max_jump_height: float, p_jump_duration: float) -> float:
	return (2 * p_max_jump_height) / pow(p_jump_duration, 2)


## Calculates the desired jump velocity from jump height and jump duration.
func calculate_jump_velocity(p_max_jump_height: float, p_jump_duration: float) -> float:
	return (2 * p_max_jump_height) / (p_jump_duration)


## Calculates jump velocity from jump height and gravity.  [br]
## Formula from
## [url]https://sciencing.com/acceleration-velocity-distance-7779124.html#:~:text=in%20every%20step.-,Starting%20from%3A,-v%5E2%3Du[/url]
func calculate_jump_velocity2(p_max_jump_height: float, p_gravity: float) -> float:
	return sqrt(abs(2 * p_gravity * p_max_jump_height)) * sign(p_max_jump_height)


## Calculates the gravity when the key is released based off the minimum jump height and jump velocity.  [br]
## Formula is from [url]https://sciencing.com/acceleration-velocity-distance-7779124.html[/url]
func calculate_release_gravity_multiplier(p_jump_velocity: float, p_min_jump_height: float, p_gravity: float) -> float:
	var release_gravity: float = pow(p_jump_velocity, 2) / (2 * p_min_jump_height)
	return release_gravity / p_gravity


## Returns a value for friction that will hit the max speed after 90% of time_to_max seconds.  [br]
## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_friction(time_to_max: float) -> float:
	return 1 - (2.30259 / time_to_max)


## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_speed(p_max_speed: float, p_friction: float) -> float:
	return (p_max_speed / p_friction) - p_max_speed
