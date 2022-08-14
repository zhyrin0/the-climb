extends Node2D

const Plant := preload("res://src/plant/plant.gd")
const Player := preload("res://src/player/player.gd")


func _ready() -> void:
	var player := $Player as Player
	player.set_camera_bounds(_get_camera_bounds())


func _unhandled_key_input(event: InputEventKey) -> void:
	if Input.is_action_just_pressed("use_item"):
		var plant := $Plants/Plant as Plant
		plant.start_vine()


func _get_camera_bounds() -> Rect2:
	var top_left := $Technical/Bounds/TopLeft as Position2D
	var bottom_rigt := $Technical/Bounds/BottomRight as Position2D
	return Rect2(top_left.global_position,
			bottom_rigt.global_position - top_left.global_position)


func _on_Plant_anchor_reached(anchor: Node2D) -> void:
	# todo: Platform.State.FLOWERY = 3
	anchor.set("state", 3)
