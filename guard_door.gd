
extends CSGBox3D

var is_open: bool = false
var opening_tween: Tween

@onready var door_sound: AudioStreamPlayer3D = $GuardDoorSound


func open_from_guard() -> void:
	if is_open:
		return

	is_open = true

	var pivot: Node3D = get_parent() as Node3D

	if pivot == null:
		push_warning("GuardDoor needs a Node3D pivot parent.")
		is_open = false
		return

	if door_sound.stream != null:
		door_sound.play()

	opening_tween = create_tween()
	opening_tween.tween_property(
		pivot,
		"rotation:y",
		pivot.rotation.y - deg_to_rad(90.0),
		3.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
