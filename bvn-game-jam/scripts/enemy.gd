extends CharacterBody2D

enum AIState {
	IDLE,
	CHASE,
	FLEE
}

@export var health: int = 1

var state: AIState = AIState.IDLE

func get_state() -> AIState:
	return state

func get_states() -> Dictionary:
	return AIState

@onready var player: CharacterBody2D = $"../Player"

@export var SPEED: float = 100
@export var CHASE_DIST: float = 300
@export var FLEE_DIST: float = 75
@export var CHASE_EXIT: float = 275
@export var FLEE_EXIT: float = 100
# TODO: what is this? I had to replace it with the the candyCorn png. Please replace this with proper path
const CANDY_CORN = preload("res://.godot/imported/candyCorn.png-762423adecd8501d4927a676262a1e7b.ctex")

var dir2Player
# fun fact: there was a bug where enemies would switch between chase and idle really fast. renaming "CHACE" to "CHASE fixed it??
# 
# make ai:
# 	move toward player if they're in the level
# 	if in the circle, move away
# shoot at player every x frames
# 

func _physics_process(delta: float) -> void:
	if player == null:
		return
	death_check()
	state_stuff()
	move_and_slide()

func death_check():
	if health <= 0:
		queue_free()


func get_hit(damage: int):
	health -= damage

func state_stuff():
	var dir2p = player.global_position - global_position
	self.dir2Player = dir2p
	var dis2p = dir2p.length()
	match state:
		AIState.IDLE:
			velocity = Vector2.ZERO
			
			if dis2p <= CHASE_DIST:
				state = AIState.CHASE
			
		AIState.CHASE:
			
			velocity = dir2p.normalized() * SPEED
			
			if dis2p <= FLEE_DIST:
				state = AIState.FLEE
			elif dis2p > CHASE_EXIT:
				state = AIState.IDLE
		
		AIState.FLEE:
			velocity = -dir2p.normalized() * SPEED
			
			if dis2p > FLEE_EXIT:
				state = AIState.CHASE
	
func can_shoot() -> bool:
	if dir2Player.length() < CHASE_EXIT:
		return true
	return false
