extends Light2D


func _ready() -> void:
	var animation_player := $AnimationPlayer as AnimationPlayer
	animation_player.play("idle")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
