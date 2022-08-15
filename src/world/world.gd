extends Node2D

const LanternLight := preload("res://src/lantern_light/lantern_light.gd")
const LanternLightScene := preload("res://src/lantern_light/lantern_light.tscn")
const Plant := preload("res://src/plant/plant.gd")
const PlantScene := preload("res://src/plant/plant.tscn")
const Player := preload("res://src/player/player.gd")


onready var _plants := $Plants as Node2D
onready var _lights := $Lights as Node2D


func _ready() -> void:
	var player := $Player as Player
	player.set_camera_bounds(_get_camera_bounds())


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
		_plants.call_deferred("add_child", plant)
		plant.set_deferred("global_position", plant_pos)


func _on_Player_lantern_lighted(lantern_global_position: Vector2) -> void:
	var lantern_light := LanternLightScene.instance() as LanternLight
	_lights.add_child(lantern_light)
	lantern_light.global_position = lantern_global_position
