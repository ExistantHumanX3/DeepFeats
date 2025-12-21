extends Node2D

@onready var sprite: Sprite2D = $Gun/Sprite2D
@onready var shaders: CanvasLayer = $"../Camera/Shaders"


@export var Bullet : PackedScene = preload("res://prefabs/player_bullet.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		shoot()


func shoot():
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Gun/BulletFrom.global_transform
	
	get_parent().knockback($Gun/BulletFrom.global_position - get_parent().global_position)
	
	var shake_layer = get_tree().get_first_node_in_group("screen_shake")
	shake_layer.start_shake(0.2)
