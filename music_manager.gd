
extends Node

@export var crossfade_duration: float = 2.0

@onready var bg_start: AudioStreamPlayer = $"../BGStart"
@onready var bg_garden: AudioStreamPlayer = $"../BGGarden"

var current_music: AudioStreamPlayer = null
var crossfade_tween: Tween


func change_music(new_music: AudioStreamPlayer) -> void:
	if new_music == null:
		return

	if current_music == new_music:
		return

	if crossfade_tween and crossfade_tween.is_running():
		crossfade_tween.kill()

	var previous_music: AudioStreamPlayer = current_music
	current_music = new_music

	# Start the new track quietly.
	if not new_music.playing:
		new_music.volume_db = -40.0
		new_music.play()

	crossfade_tween = create_tween()
	crossfade_tween.set_parallel(true)

	# Fade the new music in.
	crossfade_tween.tween_property(
		new_music,
		"volume_db",
		-20.0,
		crossfade_duration
	)

	# Fade the previous music out.
	if previous_music != null and previous_music.playing:
		crossfade_tween.tween_property(
			previous_music,
			"volume_db",
			-40.0,
			crossfade_duration
		)

		crossfade_tween.set_parallel(false)
		crossfade_tween.tween_callback(
			func() -> void:
				previous_music.stop()
				previous_music.volume_db = 0.0
		)


func _on_opening_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		change_music(bg_start)


func _on_garden_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		change_music(bg_garden)
