extends Node2D

const Vine := preload("res://src/plant/vine.gd")
const VineScene := preload("res://src/plant/vine.tscn")


onready var _vines := $Vines as Node


func start_vine() -> void:
	var lights: Array = get_tree().get_nodes_in_group("light")
	lights.sort_custom(self, "_sort_proximity")
	var anchors: Array = get_tree().get_nodes_in_group("anchor")
	anchors.sort_custom(self, "_sort_proximity")
	
	var light_direction: Vector2 = ((lights[0] as Node2D).global_position - global_position).normalized()
	var anchor_pos: Vector2 = (anchors[0] as Node2D).global_position
	
	var vine := VineScene.instance() as Vine
	vine.init(light_direction, anchor_pos)
	_vines.add_child(vine)
	


func _sort_proximity(left: Node2D, right: Node2D) -> bool:
	return global_position.distance_squared_to(left.global_position) < \
			global_position.distance_squared_to(right.global_position)
