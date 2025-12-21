extends CharacterBody2D


@export var SPEED = 200


func _physics_process(_delta) -> void:
	getInput()
	move_and_slide()

# Gets input direction as a vector so it works with controllers
func getInput():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
