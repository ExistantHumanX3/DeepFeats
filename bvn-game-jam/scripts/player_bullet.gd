extends Area2D

const bulletSpeedList: Array = [750, 200, 200]

const textureList = [TEXTURE_GUN, TEXTURE_BAT, TEXTURE_STAFF]

const TEXTURE_GUN: Texture = preload("res://assets/bullets/basic.png")
const TEXTURE_BAT: Texture = preload("res://assets/weapons/baseball stick.png")
const TEXTURE_STAFF: Texture = preload("res://assets/bullets/spellbullet.png")

var damage: float
var lifetime: float
var lifetimeMax: float
var fadeOutTimestamp: float # Works in reverse: e.g. if set to 0.5, will activate once lifetime counter hits 0.5
var bulletSpeed: int


func initialize(bulletType:int, damage:float):
	match bulletType:
		0:
			setLifetime(5)
			fadeOutTimestamp = 4.5
		1:
			setLifetime(0.1)
			fadeOutTimestamp = 0.1
		2:
			setLifetime(0.5)
			fadeOutTimestamp = 0.5
		_: # default
			push_error("You typed the player_bullet constructor wrong. (func initialize)")
			queue_free()
			return
	self.damage = damage
	bulletSpeed = bulletSpeedList[bulletType]
	changeSprite(bulletType)

func _physics_process(delta: float) -> void:
	position += transform.x * bulletSpeed * delta
	runDownTimer(delta)


func _on_body_entered(body: Node2D) -> void:
	remove_bullet_and_kill_enemies(body)

func _on_ray_cast_child_entered_tree(node: Node2D) -> void:
	if node.is_in_group("walls"):
		remove_bullet_and_kill_enemies(node)

func remove_bullet_and_kill_enemies(body: Node2D):
	if body.is_in_group("enemy"):
		body.get_hit(damage)
	queue_free()

func changeSprite(index:int):
	self.get_node("Sprite2D").texture = textureList[index]
	
func lifetime_end() -> void:
	queue_free()

func runDownTimer(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return
	if lifetime <= fadeOutTimestamp:
		self.get_node("Sprite2D").self_modulate.a = lifetime/fadeOutTimestamp
	
func setLifetime(duration:float):
	lifetime = duration
	lifetimeMax = duration
