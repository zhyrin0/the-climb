extends StaticBody2D


enum State {
	ERODED,
	ERODABLE,
	STABLE,
	FLOWERY,
}

const _PLATFORM_COLLISION_BIT := 2
export(State) var _state: int
onready var _polygon := $Polygon2D as Polygon2D
onready var _collision_rectangle := $CollisionShape2D.shape as RectangleShape2D
onready var _erosion := $ErosionTimer as Timer


func _ready() -> void:
	match _state:
		State.ERODED:
			set_collision_layer_bit(_PLATFORM_COLLISION_BIT, false)
			_polygon.color.a = 0.5
		State.ERODABLE:
			_polygon.color.a = 1.0
		State.STABLE:
			_polygon.color = Color8(192, 192, 192)
		State.FLOWERY:
			_polygon.color = Color.lightgreen


func step_on() -> void:
	if _state == State.ERODABLE and _erosion.is_stopped():
		_erosion.start()


func _on_ErosionTimer_timeout() -> void:
	_state = State.ERODED
	_polygon.color.a = 0.5
	set_collision_layer_bit(_PLATFORM_COLLISION_BIT, false)
