extends KinematicBody2D


const PLATFORM_COLLISION_BIT := 2
export(int) var movement_speed: int
export(int) var jump_height: int setget set_jump_height
export(float) var jump_time: float setget set_jump_time
export(float) var fall_gravity_multiplier: float
var _jump_velocity: float
var _gravity: float
var _velocity: Vector2
var _fallthrough_platform: Node
var _can_water_plants := false
onready var _pivot := $Pivot as Node2D
onready var _watering_can := $Pivot/WateringCan as Sprite
onready var _watering_can_area := $Pivot/WateringCan/Area2D as Area2D
onready var _fall_raycast := $FallRayCast as RayCast2D
onready var _animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	_animation_player.play("idle")


func _physics_process(delta: float) -> void:
	_velocity.x = Input.get_axis("move_left", "move_right") * movement_speed
	if _velocity.x != 0.0 and _animation_player.current_animation == "idle":
		_animation_player.play("run")
	elif _velocity.x == 0.0 and _animation_player.current_animation == "run":
		_animation_player.play("idle")
	
	var gravity_multiplier := fall_gravity_multiplier if _velocity.y > 0.0 else 1.0
	_velocity.y += _gravity * gravity_multiplier * delta
	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			set_collision_mask_bit(PLATFORM_COLLISION_BIT, false)
			_fall_raycast.set_collision_mask_bit(PLATFORM_COLLISION_BIT, false)
			_velocity.y -= _jump_velocity
		elif Input.is_action_pressed("move_fall"):
			_fallthrough_platform = _fall_raycast.get_collider()
			if _fallthrough_platform:
				add_collision_exception_with(_fallthrough_platform)
		if _fall_raycast.is_colliding():
			var platform: Object = _fall_raycast.get_collider()
			if platform.has_method("step_on"):
				platform.call("step_on")
	
	_velocity = move_and_slide(_velocity, Vector2.UP)
	_reset_collision_rules()


func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_just_pressed("move_left"):
		_pivot.scale.x = -1.0
	elif Input.is_action_just_pressed("move_right"):
		_pivot.scale.x = 1.0
	elif Input.is_action_just_pressed("use_item") and _can_water_plants:
		_watering_can.show()
		_watering_can_area.set_deferred("monitoring", true)
	elif Input.is_action_just_released("use_item"):
		_watering_can.hide()
		_watering_can_area.set_deferred("monitoring", false)


func pick_up(type: int) -> void:
	# note: Pickup.Type.WATERING_CAN
	if type == 0:
		_can_water_plants = true


func set_camera_bounds(bounds: Rect2) -> void:
	var camera := $Camera2D as Camera2D
	camera.limit_left = bounds.position.x
	camera.limit_top = bounds.position.y
	camera.limit_right = bounds.end.x
	camera.limit_bottom = bounds.end.y


func set_jump_height(new_value: int) -> void:
	jump_height = new_value
	_set_physics_values()


func set_jump_time(new_value: float) -> void:
	jump_time = new_value
	_set_physics_values()


func _reset_collision_rules() -> void:
	if _velocity.y > 0.0:
		set_collision_mask_bit(PLATFORM_COLLISION_BIT, true)
		_fall_raycast.set_collision_mask_bit(PLATFORM_COLLISION_BIT, true)
	if is_on_floor() and _fallthrough_platform:
		remove_collision_exception_with(_fallthrough_platform)
		_fallthrough_platform = null


func _set_physics_values() -> void:
	_jump_velocity = 2.0 * jump_height / jump_time if jump_time else 1.0
	_gravity = 2.0 * jump_height / pow(jump_time if jump_time else 1.0, 2.0)


func _on_Area2D_body_entered(body: Node) -> void:
	# note: Plant.State.GROWING
	body.set("state", 1)
