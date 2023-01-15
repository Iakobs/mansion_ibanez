extends MeshInstance

export(Material) var front_material: Material
export(Material) var back_material: Material

var door: Door

func _ready():
	yield(owner, "ready")
	door = owner as Door
	assert(door != null)

func _process(_delta):
	if door.player_is_in_front:
		set_surface_material(1, front_material)
	else:
		set_surface_material(1, back_material)
