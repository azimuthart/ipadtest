
extends Node3D

@export var orbit_radius: float = 3.0
@export var orbit_speed: float = 4.0
@export var orbit_height: float = 0.0

var angle: float = 0.0

func _process(delta: float) -> void:
	angle += orbit_speed * delta

	var moon = get_child(0)
	moon.position = Vector3(
		cos(angle) * orbit_radius,
		orbit_height,
		sin(angle) * orbit_radius
	)
