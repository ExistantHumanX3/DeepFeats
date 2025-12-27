extends Area2D

const bulletSpeedList: Array = [400, 150, 100]
const hitboxSizeList: Array = [[2,18],[20,64],[20,20],[20,32]]
const textureList = [TEXTURE_GUN, TEXTURE_BAT, TEXTURE_STAFF, TEXTURE_BAT_WEAK]

const TEXTURE_GUN: Texture = preload("res://assets/bullets/basic.png")
const TEXTURE_BAT: Texture = preload("res://assets/bullets/meleeBullet.png")
const TEXTURE_BAT_WEAK: Texture = preload("res://assets/bullets/meleeBullet_weak.png")
const TEXTURE_STAFF: Texture = preload("res://assets/bullets/spellbullet.png")

var damage: float
var lifetime: float
var lifetimeMax: float
var fadeOutTimestamp: float # Works in reverse: e.g. if set to 0.5, will activate once lifetime counter hits 0.5
var bulletSpeed: int
var type: int


func initialize(bulletType:int, damageInput:float, isWeak:bool = false):
	match bulletType:
		0:
			setLifetime(5)
			fadeOutTimestamp = 4.5
		1:
			setLifetime(0.1)
			fadeOutTimestamp = 0.1
		2:
			setLifetime(1)
			fadeOutTimestamp = 0.75
		_: # default
			push_error("You typed the enemy_bullet constructor wrong. (func initialize)")
			queue_free()
			return
	type = bulletType
	setHitboxDimensions(bulletType)
	self.damage = damageInput
	bulletSpeed = bulletSpeedList[bulletType]
	changeSprite(bulletType)
	if isWeak:
		changeSprite(3)
		setHitboxDimensions(3)

func _physics_process(delta: float) -> void:
	position += transform.x * bulletSpeed * delta
	runDownTimer(delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit(damage)
		queue_free()
	if body.is_in_group("walls") && type != 1:
		queue_free()

func changeSprite(index:int):
	get_node("Sprite2D").texture = textureList[index]
	
func lifetime_end() -> void:
	queue_free()

func runDownTimer(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return
	if lifetime <= fadeOutTimestamp:
		get_node("Sprite2D").self_modulate.a = lifetime/fadeOutTimestamp
	
func setLifetime(duration:float):
	lifetime = duration
	lifetimeMax = duration
	
func setHitboxDimensions(input:int):
	var rect := $CollisionShape2D.shape as RectangleShape2D
	rect.size = Vector2(hitboxSizeList[input][0],hitboxSizeList[input][1])
