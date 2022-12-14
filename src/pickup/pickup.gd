tool
extends Sprite


enum Type {
	WATERING_CAN,
	LANTERN,
}

export(Type) var type: int setget set_type
export(Texture) var watering_can: Texture
export(Texture) var lantern: Texture


func _ready() -> void:
	var animation_player := $AnimationPlayer as AnimationPlayer
	animation_player.play("idle")
	set_type(type)


func set_type(new_value: int) -> void:
	type = new_value
	match type:
		Type.WATERING_CAN:
			texture = watering_can
		Type.LANTERN:
			texture = lantern


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("pick_up"):
		body.call("pick_up", type)
	queue_free()
