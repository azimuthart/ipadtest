
extends Node3D

@export var orbit_speed: float = 1

func _process(delta: float) -> void:
	rotate_y(orbit_speed * delta)
