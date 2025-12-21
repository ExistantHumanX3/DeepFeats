extends Area2D

const SPEED = 500

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	remove_bullet_and_kill_enemies()

func _on_ray_cast_child_entered_tree(node: Node) -> void:
	if node.is_in_group("walls"):
		remove_bullet_and_kill_enemies()



func remove_bullet_and_kill_enemies():
	queue_free()
