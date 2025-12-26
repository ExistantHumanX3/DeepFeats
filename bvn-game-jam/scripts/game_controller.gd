extends Node2D

const useMouse = true

func _process(delta):
	if get_tree().get_first_node_in_group("room1") != null:
		print("sucess!")
