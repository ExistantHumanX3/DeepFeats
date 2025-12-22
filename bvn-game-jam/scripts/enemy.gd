extends CharacterBody2D

@onready var cooldown: Timer = $ShootCooldown
@onready var player: CharacterBody2D = $Player

@export var is_to_close: bool = false
@export var player_pos = player.global_position

const SPEED = 400

# TODO
# 
# make ai:
# 	move toward player if they're in the level
# 	if in the circle, move away
# shoot at player every x frames
# 

func _physics_process(delta: float) -> void:
	# turn gun to face player at all times
	look_at(player_pos)
	pass

func move_to_player():
	velocity = player_pos / SPEED
func move_away():
	pass
func shoot():
	cooldown.start()

func _on_shoot_cooldown_end() -> void:
	# Shoot bullet
	pass 
