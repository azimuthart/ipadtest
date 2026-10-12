
extends StaticBody3D

@onready var player = get_node_or_null("../Player")
@onready var animation_player = $AnimationPlayer

var doors_opened := false
var crack_started := false

func _on_door_trigger_body_entered(body: Node3D) -> void:
	if body == player and player.wearing_helmet and not doors_opened:
		doors_opened = true
		animation_player.play("OpenDoors")

func crack_open() -> void:
	if doors_opened or crack_started:
		return

	crack_started = true
	animation_player.play("CrackOpen")
func play_crack_sound() -> void:
	$CrackDoor.play()

func play_creak_sound() -> void:
	$OpenDoor.play()
