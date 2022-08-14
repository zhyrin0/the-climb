extends Node2D

const Vine := preload("res://src/plant/vine.gd")
const VineScene := preload("res://src/plant/vine.tscn")


signal anchor_reached(anchor)

enum State {
	SLEEPING,
	GROWING,
	GROWN,
	FLOWERING,
}

export(State) var state: int setget set_state
onready var _vines := $Vines as Node2D
onready var _sprite := $Sprite as Sprite


func _ready() -> void:
	set_state(state)


func set_state(new_value: int) -> void:
	state = new_value
	var sprite_frame := 0
	match new_value:
		State.GROWING:
			sprite_frame = 2
			_start_vine()
		State.GROWN:
			sprite_frame = 2
		State.FLOWERING:
			sprite_frame = 3
	if _sprite:
		_sprite.frame = sprite_frame


func _start_vine() -> void:
	var lights: Array = get_tree().get_nodes_in_group("light")
	Algorithm.remove_if(lights, funcref(self, "_not_above_plant"))
	lights.sort_custom(self, "_sort_proximity")
	var anchors: Array = get_tree().get_nodes_in_group("anchor")
	Algorithm.remove_if(anchors, funcref(self, "_not_above_plant"))
	anchors.sort_custom(self, "_sort_proximity")
	
	var nearest_light := lights[0] as Node2D
	var light_direction: Vector2 = (nearest_light.global_position - _vines.global_position).normalized()
	var light_distance_sq: float = nearest_light.global_position.distance_squared_to(_vines.global_position)
	var nearest_anchor: Node2D = null
	var anchor_distance_sq: float = INF
	if not anchors.empty():
		nearest_anchor = anchors[0] as Node2D
		anchor_distance_sq = nearest_anchor.global_position.distance_squared_to(_vines.global_position)
	var target: Node2D = nearest_light if light_distance_sq < anchor_distance_sq else nearest_anchor
	
	var vine := VineScene.instance() as Vine
	vine.init(light_direction, target.global_position)
	vine.connect("max_length_reached", self, "_on_Vine_max_length_reached", [], CONNECT_ONESHOT)
	vine.connect("anchor_reached", self, "_on_Vine_anchor_reached", [], CONNECT_ONESHOT)
	_vines.add_child(vine)


func _sort_proximity(left: Node2D, right: Node2D) -> bool:
	return global_position.distance_squared_to(left.global_position) < \
			global_position.distance_squared_to(right.global_position)


func _not_above_plant(node: Node2D, _args: Array) -> bool:
	return node.global_position.y >= _vines.global_position.y


func _on_Vine_max_length_reached() -> void:
	set_state(State.GROWN)


func _on_Vine_anchor_reached(anchor: Node2D) -> void:
	set_state(State.FLOWERING)
	emit_signal("anchor_reached", anchor)
