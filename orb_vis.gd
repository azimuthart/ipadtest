
extends Node3D

@export var move_speed: float = 0.6
@export var wander_radius: float = 5.0
@export var height_variation: float = 1.5

var home_position: Vector3
var target_position: Vector3


func _ready() -> void:
	randomize()
	home_position = global_position
	choose_new_target()


func _process(delta: float) -> void:
	global_position = global_position.move_toward(
		target_position,
		move_speed * delta
	)

	if global_position.distance_to(target_position) < 0.15:
		choose_new_target()


func choose_new_target() -> void:
	target_position = home_position + Vector3(
		randf_range(-wander_radius, wander_radius),
		randf_range(-height_variation, height_variation),
		randf_range(-wander_radius, wander_radius)
	)
