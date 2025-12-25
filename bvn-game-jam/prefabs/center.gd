extends Node2D

@onready var player: CharacterBody2D = $"../../Player"


func _physics_process(delta: float) -> void:
	if player == null:
		return
	look_at(player.global_position)
