extends Area2D

const bulletSpeedList: Array = [750, 200, 100]

const textureList = []

var damage: float
var lifetime: float
var bulletSpeed: int
func initialize(bulletType:int, damage:float):
	# sanatize input
	self.damage = damage
	match bulletType:
		0:
			setLifetime(5)
		1:
			setLifetime(0.1)
		2:
			setLifetime(1)
		_: # default
			push_error("You typed the player_bullet constructor wrong. (func initialize)")
			queue_free()
			return
	bulletSpeed = bulletSpeedList[bulletType]

func _physics_process(delta: float) -> void:
	position += transform.x * bulletSpeed * delta
	runDownTimer(delta)


func _on_body_entered(body: Node2D) -> void:
	remove_bullet_and_kill_enemies()

func _on_ray_cast_child_entered_tree(node: Node) -> void:
	if node.is_in_group("walls"):
		remove_bullet_and_kill_enemies()

func remove_bullet_and_kill_enemies():
	queue_free()

func changeSprite(index:int):
	$Gun/Sprite2D.texture = textureList[index]
	
func lifetime_end() -> void:
	queue_free()

func runDownTimer(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
func setLifetime(duration:float):
	lifetime = duration
