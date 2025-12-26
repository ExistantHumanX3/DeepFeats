extends Area2D

@export var SPEED = 875

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit(1)
	queue_free()
