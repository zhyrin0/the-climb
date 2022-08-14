tool
extends Path2D
"""The shape of a vine is defined with a path.
The end point of the path is the closest anchor reachable OR the closest light source.
Each point except for the last of the path has it's out hander facing the lastest closest light source.
"""


signal max_length_reached
signal anchor_reached(anchor)

enum State {
	GROWING,
	WITHERING,
	ANCHORED,
}

const _ONE_PIXEL_SQ := 1.0
export(State) var state: int setget set_state
export(float) var _max_length: float
export(float) var _growth_speed: float
export(Color) var _debug_color: Color
onready var _path_follow := $PathFollow2D as PathFollow2D
onready var _tip := $PathFollow2D/Tip as Area2D
onready var _line := $Line2D as Line2D


func init(light_direction: Vector2, target_global_position: Vector2) -> void:
	yield(self, "ready")
	
	set_state(State.GROWING)
	create_light_seeking_curve(light_direction)
	if target_global_position != Vector2.INF:
		update_targeting_curve(target_global_position)


func _process(delta: float) -> void:
	update()
	if curve:
		grow(delta)


func _draw() -> void:
	if OS.is_debug_build():
		draw_circle(Vector2.ZERO, _max_length, _debug_color)
		if curve:
			for i in range(curve.get_point_count()):
				var point_position: Vector2 = curve.get_point_position(i)
				draw_line(point_position, point_position + curve.get_point_out(i), _debug_color, 2.5)
				draw_circle(point_position, 5.0, _debug_color)


func create_light_seeking_curve(light_direction: Vector2) -> void:
	curve = Curve2D.new()
	curve.add_point(Vector2.ZERO, Vector2.ZERO, light_direction * _max_length * 0.5)
	curve.add_point(light_direction * _max_length)
	_path_follow.offset = 0
	_line.add_point(_path_follow.position)


func update_targeting_curve(target_global_position: Vector2) -> void:
	var target_position: Vector2 = to_local(target_global_position)
	if position.distance_squared_to(target_global_position) > _max_length*_max_length:
		target_position = target_position.normalized() * _max_length
	curve.set_point_position(1, target_position)


func grow(delta: float) -> void:
	_path_follow.offset += _growth_speed * delta
	if _path_follow.position.distance_squared_to(_line.points[-1]) > _ONE_PIXEL_SQ:
		_line.add_point(_path_follow.position)
	if _path_follow.unit_offset == 1.0:
		set_process(false)
		_tip.set_deferred("monitoring", false)
		emit_signal("max_length_reached")
		set_state(State.WITHERING)


func set_state(new_value: int) -> void:
	state = new_value
	if new_value == State.WITHERING:
		var tween: SceneTreeTween = create_tween()
		tween.tween_property(_line, "default_color", Color.chocolate, 1.0)
		tween.play()


func _on_Tip_body_entered(anchor: Node) -> void:
	set_state(State.ANCHORED)
	set_process(false)
	_tip.set_deferred("monitoring", false)
	emit_signal("anchor_reached", anchor)
