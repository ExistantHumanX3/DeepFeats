extends Area2D

@export var SPEED = 875
@export var damage: int = 1
@onready var sprite: Sprite2D = $Sprite2D

@onready var basic = preload("res://assets/bullets/basic.png")
@onready var spell = preload("res://assets/bullets/spellbullet.png")


func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta

func instantiate(type: int):
	match type:
		0:
			set_image(basic)
		1:
			set_image(spell)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit(damage)
	queue_free()

func set_image(img: Texture):
	sprite.texture = img
