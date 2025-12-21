extends CharacterBody2D

const Obamaness = 99999999
const moveSpeed = 67
func _physics_process(delta: float) -> void:
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction*moveSpeed
	
	move_and_slide()
