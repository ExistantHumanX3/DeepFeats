extends Node2D

@onready var sprite: Sprite2D = $Gun/Sprite2D

const rotate_limit = 90.0
# Have bullet reference here
const PLAYER_BULLET = preload("uid://2x07em04hodb")

@export var Bullet : PackedScene = preload("res://prefabs/player_bullet.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		shoot()


func shoot():
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)
	b.position = $Gun/BulletFrom.global_position
	b.rotation = $Gun/BulletFrom.global_rotation
