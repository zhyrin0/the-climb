extends Node2D

const Player := preload("res://src/player/player.gd")


func _ready() -> void:
	var player := $Player as Player
	player.set_camera_bounds(_get_camera_bounds())


func _get_camera_bounds() -> Rect2:
	var top_left := $Technical/Bounds/TopLeft as Position2D
	var bottom_rigt := $Technical/Bounds/BottomRight as Position2D
	return Rect2(top_left.global_position,
			bottom_rigt.global_position - top_left.global_position)
