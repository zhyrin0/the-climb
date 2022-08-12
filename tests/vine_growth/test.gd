extends Node2D

const Plant := preload("res://src/plant/plant.gd")


var _dragged_node: Node2D = null
onready var _plant := $Plant as Plant
onready var _light_1 := $Light1 as Node2D
onready var _light_2 := $Light2 as Node2D
onready var _anchor_1 := $Anchor1 as Node2D
onready var _anchor_2 := $Anchor2 as Node2D


func _physics_process(_delta: float) -> void:
	if _dragged_node:
		_dragged_node.position = get_local_mouse_position()


func _on_Light1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_button := event as InputEventMouseButton
	if not mouse_button or mouse_button.button_index != BUTTON_LEFT:
		return
	_on_draggable_button_event(_light_1, event)


func _on_Light2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_button := event as InputEventMouseButton
	if not mouse_button or mouse_button.button_index != BUTTON_LEFT:
		return
	_on_draggable_button_event(_light_2, event)


func _on_Anchor1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_button := event as InputEventMouseButton
	if not mouse_button or mouse_button.button_index != BUTTON_LEFT:
		return
	_on_draggable_button_event(_anchor_1, event)


func _on_Anchor2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_button := event as InputEventMouseButton
	if not mouse_button or mouse_button.button_index != BUTTON_LEFT:
		return
	_on_draggable_button_event(_anchor_2, event)


func _on_draggable_button_event(node: Node2D, mouse_button: InputEventMouseButton) -> void:
	if mouse_button.pressed:
		_dragged_node = node
	else:
		_dragged_node = null


func _on_Button_pressed() -> void:
	_plant.start_vine()
