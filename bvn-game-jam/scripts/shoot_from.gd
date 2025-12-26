extends Node2D


var can_shoot = true
@export var strength: int = 1
@onready var this: Marker2D = $"."

@onready var Bullet = preload("res://prefabs/enemy_bullet.tscn")
@onready var cooldown: Timer = $ShootCooldown
@onready var center: Node2D = $".."
@onready var enemy: CharacterBody2D = $"../.."
@onready var particles: GPUParticles2D = $Particles

@export var bullet_type: int = 0

func _ready():
	particles.emitting = false


func _physics_process(delta: float) -> void:
	if can_shoot && enemy.get_state() == enemy.AIState.CHASE:
		shoot()

func shoot():
	if cooldown == null || !enemy.can_shoot():
		return
	cooldown.start()
	particles.restart()
	var shake_layer = get_tree().get_first_node_in_group("screen_shake")
	shake_layer.start_shake(0.2)
	can_shoot = false


func _on_shoot_cooldown_timeout() -> void:
	var b = Bullet.instantiate(bullet_type)
	get_tree().root.add_child(b)
	b.transform = center.transform
	b.position = this.global_position
	can_shoot = true
