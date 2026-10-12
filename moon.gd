
extends Node3D

@export var orbit_radius: float = 2.0
@export var orbit_speed: float = 1.0
@export var orbit_height: float = 0.0
@export var starting_angle: float = 180.0

var angle: float = 0.0

func _ready() -> void:
	angle = deg_to_rad(starting_angle)

func _process(delta: float) -> void:
	angle += orbit_speed * delta

	var moon = get_child(0)
	moon.position = Vector3(
		cos(angle) * orbit_radius,
		orbit_height,
		sin(angle) * orbit_radius
	)
