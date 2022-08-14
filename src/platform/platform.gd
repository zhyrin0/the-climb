extends StaticBody2D


enum State {
	ERODED,
	ERODABLE,
	STABLE,
	FLOWERY,
}

const _PLATFORM_COLLISION_BIT := 2
export(State) var state: int setget set_state
onready var _sprite := $Sprite as Sprite
onready var _collision_rectangle := $CollisionShape2D.shape as RectangleShape2D
onready var _erosion := $ErosionTimer as Timer


func _ready() -> void:
	set_state(state)


func step_on() -> void:
	if state == State.ERODABLE and _erosion.is_stopped():
		_erosion.start()


func get_plant_global_position() -> Vector2:
	return ($PlantPosition as Position2D).global_position


func set_state(new_value: int) -> void:
	state = new_value
	set_collision_layer_bit(_PLATFORM_COLLISION_BIT, state != State.ERODED)
	if _sprite:
		_sprite.modulate.a = 1.0
		match state:
			State.ERODED:
				_sprite.frame = 0
				_sprite.modulate.a = 0.75
			State.ERODABLE:
				_sprite.frame = 1
			State.STABLE:
				_sprite.frame = 2
			State.FLOWERY:
				_sprite.frame = 3


func _on_ErosionTimer_timeout() -> void:
	set_state(State.ERODED)
