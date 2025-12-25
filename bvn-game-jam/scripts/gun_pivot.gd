extends Node2D

@onready var sprite: Sprite2D = $Gun/Sprite2D
@onready var shaders: CanvasLayer = $"../Camera/Shaders"
@onready var cooldown: Timer = $Gun/Cooldown
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
# TODO: please add sound of empty gun
@onready var particles: GPUParticles2D = $Gun/BulletFrom/Particles

# Player Inventory
var ammo = [69420, 10, 2] # 0: starbreaker; 1: toodles roll; 2: rerro focher
var currentWeapon = 0 # 0: gun; 1: baseball bat; 2: staff

var canShoot = true;
var gunRecoil = 100 # Why var? An upgrade will allow the bat to dash further 
var batRecoil = -300
var staffRecoil = 0
var recoilList: Array = [gunRecoil, batRecoil, staffRecoil]
var currentRecoil = 100
# textures
const TEXTURE_GUN: Texture = preload("res://assets/weapons/gun2.png")
const TEXTURE_BAT: Texture = preload("res://assets/weapons/baseball stick.png")
const TEXTURE_STAFF: Texture = preload("res://assets/weapons/staph.png")
const textureList: Array  = [TEXTURE_GUN, TEXTURE_BAT, TEXTURE_STAFF]
const offsetList: Array = [[8,-2],[8,0],[8,0]]# TODO: figure out how to turn off rotation for the staff


@export var Bullet : PackedScene = preload("res://prefabs/player_bullet.tscn")
@onready var game: Node2D = $"../../GameController"


func _ready():
	particles.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game.useMouse:
		look_at(get_global_mouse_position()) # TODO: this broke for some reason please fix it
	else:
		var input_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		var look_dir = input_dir + global_position
		look_at(look_dir)
	weaponSwapInput()
	fireCheck()

func weaponSwapInput():
	if Input.is_action_just_pressed("weapon_1"):
		swapWeapon(0)
	if Input.is_action_just_pressed("weapon_2"):
		swapWeapon(1)
	if Input.is_action_just_pressed("weapon_3"):
		swapWeapon(2)

func fireCheck():
	if !canShoot:
		return
	if Input.is_action_just_pressed("shoot"):
		# Special behavior for Baseballbat (can fire without ammo but much weaker)
		if currentWeapon == 1:
			canShoot = false
			cooldown.start()
			if ammo[currentWeapon] > 0:
				shoot()
			else:
				shoot()
			return
		# Other weapon behavior
		if ammo[currentWeapon] > 0:
			ammo[currentWeapon] -= 1
			shoot()
			canShoot = false
			cooldown.start()
		
		else: 
			# Play blank sound.
			return

func shoot():
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Gun/BulletFrom.global_transform
	b.initialize(currentWeapon,1)
	
	get_parent().knockback(gunRecoil*($Gun/BulletFrom.global_position - get_parent().global_position))
	
	shoot_sound.play()
	
	var shake_layer = get_tree().get_first_node_in_group("screen_shake")
	shake_layer.start_shake(0.2)
	
	particles.restart()


func _on_cooldown_end() -> void:
	canShoot = true;

func changeSprite(index:int):
	$Gun/Sprite2D.texture = textureList[index]

func swapWeapon(index:int):
	changeSprite(index)
	currentWeapon = index
	currentRecoil = recoilList[index]
	# $Player/GunPivot.transform = Vector2(offsetList[index][0],offsetList[index][1]) TODO: figure out how to do change the offset
