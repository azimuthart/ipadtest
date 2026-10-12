
extends Node3D

@export var move_speed: float = 3.0
@export var wander_radius: float = 10.0
@export var min_height: float = 1.0
@export var max_height: float = 3.0
@export var steering_strength: float = 0.35
@export var vertical_speed: float = 0.25

var home_position: Vector3
var noise := FastNoiseLite.new()
var noise_time := 0.0
var vertical_offset := 2.0
var vertical_target := 2.0
var vertical_timer := 0.0


func _ready() -> void:
	randomize()
	home_position = global_position
	noise.seed = randi()
	noise.frequency = 0.12
	vertical_offset = (min_height + max_height) * 0.5
	vertical_target = randf_range(min_height, max_height)


func _process(delta: float) -> void:
	noise_time += delta * steering_strength

	# Smooth, continuously changing horizontal direction.
	var direction := Vector3(
		noise.get_noise_1d(noise_time),
		0.0,
		noise.get_noise_1d(noise_time + 100.0)
	).normalized()

	var offset := global_position - home_position
	var horizontal_offset := Vector2(offset.x, offset.z)

	# Gently steer back when approaching the boundary.
	if horizontal_offset.length() > wander_radius * 0.65:
		var inward := Vector3(-offset.x, 0.0, -offset.z).normalized()
		var pull_strength := clampf(
			(horizontal_offset.length() - wander_radius * 0.65)
			/ (wander_radius * 0.35),
			0.0,
			1.0
		)
		direction = direction.lerp(inward, pull_strength).normalized()

	global_position += direction * move_speed * delta

	# Choose a new height occasionally, then ease toward it.
	vertical_timer -= delta
	if vertical_timer <= 0.0:
		vertical_target = randf_range(min_height, max_height)
		vertical_timer = randf_range(5.0, 9.0)

	vertical_offset = move_toward(
		vertical_offset,
		vertical_target,
		vertical_speed * delta
	)

	global_position.y = home_position.y + vertical_offset
