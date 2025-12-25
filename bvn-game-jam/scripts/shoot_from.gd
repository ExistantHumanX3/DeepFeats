extends Node2D


var can_shoot = true
@onready var this: Marker2D = $"."

@onready var Bullet = preload("res://prefabs/player_bullet.tscn")
@onready var cooldown: Timer = $ShootCooldown
@onready var center: Node2D = $".."
@onready var enemy: CharacterBody2D = $"../.."



func _physics_process(delta: float) -> void:
	if can_shoot && enemy.get_state() == enemy.AIState.CHASE:
		shoot()

func shoot():
	if cooldown == null:
		return
	cooldown.start()
	can_shoot = false


func _on_shoot_cooldown_timeout() -> void:
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)
	b.transform = center.transform
	b.position = this.global_position
	can_shoot = true
