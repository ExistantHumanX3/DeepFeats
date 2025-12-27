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
	can_shoot = false


func _on_shoot_cooldown_timeout() -> void:
	actuallyshoot()

func actuallyshoot():
	match get_parent().get_parent().enemyType: # In hindsight, I should've created a weapon Class but im too lazy and new to godot :D
		0:
			createBullet(1,randf_range(-5.0,5.0))
			particles.restart()
			weaponCooldown(randf_range(0.8,1.5))
		1:
			createBullet(1,0)
			weaponCooldown(randf_range(1.0,3.0))
		2:
			bulletFan(8,360,1)
			weaponCooldown(2)
	assert (get_parent().get_parent().enemyType != 3 || get_parent().get_parent().enemyType == null)
	
func weaponCooldown(input:float):
	get_node("ShootCooldown").wait_time = input
	can_shoot = false
	cooldown.start()
	
func createBullet(damage:float, rotOffset:float = 0, isWeak:bool = false):
	# create bullet!!
	var b := Bullet.instantiate()
	get_tree().root.add_child(b) 
	b.initialize(get_parent().get_parent().enemyType,damage,isWeak)
	
	# give bullet place to exist!!
	self.rotation_degrees += rotOffset
	b.transform = global_transform
	self.rotation_degrees -= rotOffset

func bulletFan(count:int, angle:float, damage:int = 1):
	for i:int in count-1:
		createBullet(damage, (-angle/2)+i*(angle/(count-1)))
	createBullet(damage, (-angle/2)+count*(angle/count))
