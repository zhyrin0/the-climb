extends Node2D

const Plant := preload("res://src/plant/plant.gd")
const PlantScene := preload("res://src/plant/plant.tscn")
const Player := preload("res://src/player/player.gd")


onready var _plants := $Plants as Node2D


func _ready() -> void:
	var player := $Player as Player
	player.set_camera_bounds(_get_camera_bounds())


func _unhandled_key_input(event: InputEventKey) -> void:
	if Input.is_action_just_pressed("use_item"):
		var plant: Plant = _plants.get_child(_plants.get_child_count() - 1)
		plant.set_state(Plant.State.GROWING)


func _get_camera_bounds() -> Rect2:
	var top_left := $Technical/Bounds/TopLeft as Position2D
	var bottom_rigt := $Technical/Bounds/BottomRight as Position2D
	return Rect2(top_left.global_position,
			bottom_rigt.global_position - top_left.global_position)


func _on_Plant_anchor_reached(anchor: Node2D) -> void:
	# todo: Platform.State.FLOWERY = 3
	anchor.set("state", 3)
	if anchor.has_method("get_plant_global_position"):
		var plant_pos: Vector2 = anchor.call("get_plant_global_position")
		var plant := PlantScene.instance() as Plant
		plant.connect("anchor_reached", self, "_on_Plant_anchor_reached", [], CONNECT_ONESHOT)
		_plants.add_child(plant)
		plant.global_position = plant_pos
