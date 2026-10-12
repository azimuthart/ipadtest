
extends Node3D

var player: CharacterBody3D = null
var player_in_range: bool = false
var gate_open: bool = false
var gate_tween: Tween

@onready var gate_pivot: Node3D = $GatePivot


func _ready() -> void:
	player = get_node_or_null("../Player") as CharacterBody3D


func _on_gate_interaction_area_body_entered(body: Node3D) -> void:
	if body != player:
		return

	player_in_range = true
	player.show_portcullis_prompt()


func _on_gate_interaction_area_body_exited(body: Node3D) -> void:
	if body != player:
		return

	player_in_range = false
	player.hide_portcullis_prompt()



func interact() -> void:
	if not player_in_range or player == null or gate_open:
		return

	if player.equipped_name == "Contemplation":
		player.show_portcullis_dialogue("She's waiting for you")
		open_gate()
	else:
		player.show_portcullis_dialogue("None shall pass without her approval")


func open_gate() -> void:
	if gate_open:
		return

	gate_open = true

	gate_tween = create_tween()
	gate_tween.tween_property(
		gate_pivot,
		"position:y",
		gate_pivot.position.y + 4.0,
		5.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
