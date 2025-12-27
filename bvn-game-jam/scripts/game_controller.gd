extends Node2D

var useMouse = true
@onready var room_1_blockade: StaticBody2D = $"../Room1Blockade"
@onready var room_2_blockade_1: StaticBody2D = $"../Room2Blockade1"
@onready var room_2_blockade_2: StaticBody2D = $"../Room2Blockade2"
@onready var room_2_blockade_3: StaticBody2D = $"../Room2Blockade3"
@onready var room_3_blockade: StaticBody2D = $"../Room3Blockade"
@onready var player: CharacterBody2D = $"../Player"

var room_count: int = 0

func _process(delta):
	switch_to_controller()
	switch_to_keyboard()
	
	end_room(1)
	end_room(2)
	end_room(3)
	end_room(4)

func end_room(num: int):
	if get_tree().get_nodes_in_group("room" + str(num)).is_empty() && room_count == num - 1:
		remove_blockade(num)

func remove_blockade(num: int):
	match num:
		1:
			room_1_blockade.queue_free()
			room_count += 1
			player.update_ammo(0, 3)
			player.heal(1)
		2:
			room_2_blockade_1.queue_free()
			room_2_blockade_2.queue_free()
			room_2_blockade_3.queue_free()
			room_count += 1
			player.update_ammo(0, 1)
			player.heal(1)
		3:
			if room_3_blockade != null:
				room_3_blockade.queue_free()
			player.update_ammo(0, 1)
		4:
			if room_3_blockade != null:
				room_3_blockade.queue_free()
			player.heal(3)
			player.update_ammo(2, 2)
			player.update_ammo(0, 4)
		5:
			player.heal(999999)
			player.update_ammo(0, -999)
			player.update_ammo(1, -999)
			player.update_ammo(2, -999)
		_:
			pass

func switch_to_controller():
	if Input.is_action_just_pressed("switch_to_controller"):
		useMouse = false
func switch_to_keyboard():
	if Input.is_action_just_pressed("switch_to_keyboard"):
		useMouse = true
