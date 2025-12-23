extends Node2D

@onready var sprite: Sprite2D = $Gun/Sprite2D
@onready var shaders: CanvasLayer = $"../Camera/Shaders"
@onready var cooldown: Timer = $Gun/Cooldown
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

var canShoot = true;
const recoilStrength = 100

@export var Bullet : PackedScene = preload("res://prefabs/player_bullet.tscn")
@onready var game: Node2D = $"../../GameController"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	assert(game.useMouse, "for some reason game.useMouse is false???")
	if game.useMouse:
		look_at(get_global_mouse_position()) # TODO: this broke for some reason please fix it
	else:
		var input_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		var look_dir = input_dir + global_position
		look_at(look_dir)
	
	if Input.is_action_just_pressed("shoot") && canShoot:
		shoot()
		canShoot = false
		cooldown.start()


func shoot():
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Gun/BulletFrom.global_transform
	
	get_parent().knockback(recoilStrength*($Gun/BulletFrom.global_position - get_parent().global_position))
	
	shoot_sound.play()
	
	var shake_layer = get_tree().get_first_node_in_group("screen_shake")
	shake_layer.start_shake(0.2)



func _on_cooldown_end() -> void:
	canShoot = true;
