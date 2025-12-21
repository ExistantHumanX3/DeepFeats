extends CanvasLayer

var curStrength = 0
@onready var shake: ColorRect = $ShakeShader
@onready var mat := shake.material

func _process(delta: float) -> void:
	curStrength = max(curStrength - delta, 0)
	
	mat.set_shader_parameter("ShakeStrength",curStrength)
	
	if curStrength <= 0.0:
		mat.set_shader_parameter("enabled", false)

func start_shake(strength: float):
	curStrength = strength
	mat.set_shader_parameter("enabled", true)
