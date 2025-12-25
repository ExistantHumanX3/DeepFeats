extends CharacterBody2D

# Movement variables
var kb_vector: Vector2
var move_vector: Vector2
var anim_timer: int = 0
var is_dashing: bool = false
var can_dash: bool = true;


@onready var sprites: AnimatedSprite2D = $AnimatedSprite2D
@onready var shaders: CanvasLayer = $Camera/Shaders



const SPEED = 200
const DASH_SPEED = 4.0
const dash_timer = 5

func _physics_process(delta) -> void:
	sprites.play("idle")
	movementInput()
	move_and_slide()

# Gets input direction as a vector so it works with controllers
func movementInput():
	# Sets movement direction
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Update move_vector
	move_vector = input_vector
	
	# Check if player dashes
	if Input.is_action_just_pressed("dash") && !is_dashing && can_dash:
		is_dashing = true
	
	if is_dashing && move_vector != Vector2(0,0):
		if anim_timer == 0:
			shaders.start_shake(0.1)
		play_anim("dash")
		anim_timer += 1
		var dash_vector = DASH_SPEED * move_vector
		move_vector += dash_vector
		can_dash = false
		if anim_timer >= dash_timer:
			anim_timer = 0
			play_anim("idle")
			is_dashing = false
			$DashCooldown.start()
	else :
		play_anim("idle")
		
	
	# Check if knockback is existing
	if kb_vector.length() > 0:
		# Each frame the knockback exists, subtract it's speed by an increasing amount each time
		# starting at 0.05 and increases by the power of the lerp... idk what that is, but it works
		kb_vector = lerp(kb_vector, Vector2(0, 0), 0.05)
		
		
	# Apply speed separately from knockback
	move_vector *= SPEED
	# Apply knockback
	move_vector -= kb_vector
	
	velocity = move_vector
	


func knockback(kb_vector: Vector2):
	self.kb_vector = kb_vector * get_physics_process_delta_time()

func play_anim(name: String):
	sprites.stop()
	sprites.play(name)

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
