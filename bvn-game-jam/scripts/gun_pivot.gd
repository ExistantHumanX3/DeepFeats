extends Node2D

@onready var sprite: Sprite2D = $Gun/Sprite2D
@onready var shaders: CanvasLayer = $"../Camera/Shaders"
@onready var cooldown: Timer = $Gun/Cooldown
@onready var gun_sound: AudioStreamPlayer2D = $ShootSound
@onready var melee_sound: AudioStreamPlayer2D = $MeleeSound
@onready var spell_sound: AudioStreamPlayer2D = $SpellSound
@onready var gunBlank_sound: AudioStreamPlayer2D = $ShootBlankSound
@onready var meleeBlank_sound: AudioStreamPlayer2D = $MeleeBlankSound
@onready var spellBlank_sound: AudioStreamPlayer2D = $SpellBlankSound
@onready var cheater_sound: AudioStreamPlayer2D = $Wario

@onready var particles: GPUParticles2D = $Gun/BulletFrom/Particles

# Player Inventory
var ammo = [15, 4, 3] # 0: starbreaker; 1: toodles roll; 2: rerro focher
var currentWeapon = 0 # 0: gun; 1: baseball bat; 2: staff

var canShoot = true;
var gunRecoil = 100 # Why var? An upgrade will allow the bat to dash further 
var batRecoil = -200
var staffRecoil = 250
var recoilList: Array = [gunRecoil, batRecoil, staffRecoil]
var currentRecoil: float = 100
var pivotOffset: float = 0
# textures
const TEXTURE_GUN: Texture = preload("res://assets/weapons/gun2.png")
const TEXTURE_BAT: Texture = preload("res://assets/weapons/baseball stick.png")
const TEXTURE_STAFF: Texture = preload("res://assets/weapons/staph.png")
const textureList: Array  = [TEXTURE_GUN, TEXTURE_BAT, TEXTURE_STAFF]
const offsetList: Array = [[2,1],[12,0],[-3,0]]

@export var Bullet: PackedScene = preload("res://prefabs/player_bullet.tscn")
@onready var game: Node2D = $"../../GameController"


func _ready():
	particles.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game.useMouse:
		look_at(get_global_mouse_position()) 
		rotation += deg_to_rad(pivotOffset)
	else:
		var input_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		var look_dir = input_dir + global_position
		look_at(look_dir)
	weaponSwapInput()
	if(currentWeapon == 1):
		resetBat()
	fireCheck()
	if Input.is_action_just_pressed("debug_getAmmoBack"):
		ammo = [10, 10, 10]
		cheater_sound.play()
		

func weaponSwapInput():
	if Input.is_action_just_pressed("weapon_1"):
		swapWeapon(0)
	if Input.is_action_just_pressed("weapon_2"):
		swapWeapon(1)
	if Input.is_action_just_pressed("weapon_3"):
		swapWeapon(2)

func update_ammo(index: int, amount: int):
	ammo[index] += amount

func fireCheck():
	if !canShoot:
		return
	if !Input.is_action_just_pressed("shoot"):
		return
	if(ammo[currentWeapon] < 1):
		getCurrentWeaponBlankSound().play()
		if currentWeapon != 1:
			return
		# shoot anyways, but weak
		look_at(get_global_mouse_position())
		createBullet(1,-5,true)
		get_parent().knockback(currentRecoil/2*($Gun/BulletFrom.global_position - get_parent().global_position))
		pivotOffset = -50
		rotation += deg_to_rad(pivotOffset)
		weaponCooldown(0.6)
		return
	if ammo[currentWeapon] > 0:
		ammo[currentWeapon] -= 1
	shoot()

func shoot():
	var shake_layer = get_tree().get_first_node_in_group("screen_shake")
	look_at(get_global_mouse_position()) 
	match currentWeapon: # In hindsight, I should've created a weapon Class but im too lazy and new to godot :D
		0:
			createBullet(1,randf_range(-1,1))
			shake_layer.start_shake(0.2)
			particles.restart()
			weaponCooldown(0.2)
		1:
			createBullet(3,-15)
			shake_layer.start_shake(0.1)
			pivotOffset = -70
			weaponCooldown(0.3)
		2:
			bulletFan(10,90,1)
			weaponCooldown(2.5)
	# universal things
	getCurrentWeaponSound().play()
	get_parent().knockback(currentRecoil*($Gun/BulletFrom.global_position - get_parent().global_position))
	rotation += deg_to_rad(pivotOffset)
func createBullet(damage:float, rotOffset:float = 0, isWeak:bool = false):
	# create bullet!!
	Bullet = preload("res://prefabs/player_bullet.tscn")
	var b := Bullet.instantiate()
	get_tree().root.add_child(b) 
	b.initialize(currentWeapon,damage,isWeak)
	
	# give bullet place to exist!!
	self.rotation_degrees += rotOffset
	b.transform = $Gun/BulletFrom.global_transform
	self.rotation_degrees -= rotOffset
	
func _on_cooldown_end() -> void:
	canShoot = true;

func changeSprite(index:int):
	$Gun/Sprite2D.texture = textureList[index]

func swapWeapon(index:int):
	changeSprite(index)
	currentWeapon = index
	currentRecoil = recoilList[index]
	get_node("Gun").get_node("Sprite2D").offset = Vector2(offsetList[index][0], offsetList[index][1])
	if index == 1:
		pivotOffset = 70
	else:
		pivotOffset = 0

func getCurrentWeaponSound() -> AudioStreamPlayer2D:
	match currentWeapon:
		0:
			return gun_sound
		1:
			return melee_sound
		2:
			return spell_sound
		_:
			push_error("Invalid weapon (range 0-2, got " + currentWeapon + ")")
			return gun_sound
			
func getCurrentWeaponBlankSound() -> AudioStreamPlayer2D:
	match currentWeapon:
		0:
			return gunBlank_sound
		1:
			return meleeBlank_sound
		2:
			return spellBlank_sound
		_:
			push_error("Invalid weapon (range 0-2, got " + currentWeapon + ")")
			return gun_sound

func bulletFan(count:int, angle:float, damage:int = 1):
	for i:int in count-1:
		createBullet(damage, (-angle/2)+i*(angle/(count-1)))
	createBullet(damage, (-angle/2)+count*(angle/count))

func weaponCooldown(input:float):
	get_node("Gun/Cooldown").wait_time = input
	canShoot = false
	cooldown.start()

func resetBat():
	var resetPosition:float
	var resetSpeed: float
	if ammo[1] < 1:
		resetPosition = 30
		resetSpeed = 3
	else:
		resetPosition = 70
		resetSpeed = 10
	if(pivotOffset == resetPosition):
		return
	if(pivotOffset-resetPosition > resetSpeed):
		pivotOffset -= resetSpeed
	elif(pivotOffset-resetPosition < -resetSpeed):
		pivotOffset += resetSpeed
	else:
		pivotOffset = resetPosition

func giveAmmo(amount:int, type:int):
	ammo[type] += amount


func _on_reload_timer_timeout() -> void:
	ammo = [15, 4, 3]
