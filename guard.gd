
extends Node3D

var player: CharacterBody3D = null
var player_in_range: bool = false

@onready var guard_mesh: MeshInstance3D = $MeshInstance3D

var original_material: StandardMaterial3D = null
var flash_tween: Tween


func _ready() -> void:
	player = get_node_or_null("../../Player") as CharacterBody3D

	if player == null:
		player = get_node_or_null("../Player") as CharacterBody3D

	if guard_mesh != null:
		var source_material: StandardMaterial3D = guard_mesh.get_active_material(0) as StandardMaterial3D

		if source_material != null:
			original_material = source_material.duplicate() as StandardMaterial3D
			guard_mesh.material_override = original_material


func _on_interaction_area_guard_body_entered(body: Node3D) -> void:
	if body != player:
		return

	player_in_range = true
	player.near_guard = true
	player.show_guard_prompt()


func _on_interaction_area_guard_body_exited(body: Node3D) -> void:
	if body != player:
		return

	player_in_range = false
	player.near_guard = false
	player.hide_guard_prompt()


func interact() -> void:
	if not player_in_range or player == null:
		return

	var dialogue: String

	if player.equipped_name == "Sonder":
		dialogue = "[R - Remove Mask] Your mind moves to freely to others to inspect your own neutrality"
		flash_red()

	elif player.equipped_name == "Determination":
		dialogue = "[R - Remove Mask] As determined as you may be, not all doors bow to sheer will alone"
		flash_red()

	elif player.equipped_name == "Contemplation":
		dialogue = "My, my, now she'll be ready for you"

	else:
		dialogue = "Doors unlock for those who can remain neutral in moments of contention"

		var guard_door: Node = get_node_or_null("GuardDoorPivot/GuardDoor")

		if guard_door != null and guard_door.has_method("open_from_guard"):
			guard_door.open_from_guard()

	player.show_guard_dialogue(dialogue)



func flash_red() -> void:
	if guard_mesh == null or original_material == null:
		return

	if flash_tween != null and flash_tween.is_running():
		flash_tween.kill()

	var red_material: StandardMaterial3D = original_material.duplicate() as StandardMaterial3D
	guard_mesh.material_override = red_material

	red_material.albedo_color = Color(1.0, 0.0, 0.0)
	red_material.emission_enabled = true
	red_material.emission = Color(1.0, 0.0, 0.0)
	red_material.emission_energy_multiplier = 1.0

	flash_tween = create_tween()
	flash_tween.tween_interval(1.0)
	flash_tween.tween_callback(func() -> void:
		guard_mesh.material_override = original_material
	)
