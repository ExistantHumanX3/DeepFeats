extends CharacterBody2D


var kb_vector: Vector2
var move_vector: Vector2

@export var SPEED = 200


func _physics_process(delta) -> void:
	getInput()
	move_and_slide()

# Gets input direction as a vector so it works with controllers
func getInput():
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_vector = input_vector - kb_vector
	
	if kb_vector.length() > 0:
		kb_vector = lerp(kb_vector, Vector2(0, 0), 0.05)
	
	velocity = move_vector * SPEED


func knockback(kb_vector: Vector2):
	self.kb_vector = kb_vector * get_physics_process_delta_time()
