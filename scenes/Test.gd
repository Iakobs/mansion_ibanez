extends Spatial

onready var demo_mesh: MeshInstance = $"%demo_mesh"

func _process(_delta: float) -> void:
	demo_mesh.global_translation = PlayerStats.touching_point
