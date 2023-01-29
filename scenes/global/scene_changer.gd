extends Control

onready var progress_bar: ProgressBar = $"%ProgressBar"
onready var player: AnimationPlayer = $"%AnimationPlayer"

var thread: Thread

func _ready() -> void:
	turn_off()

func load_scene(path: String) -> void:
	thread = Thread.new()
	var _error := thread.start( self, "_thread_load", path)
	get_tree().current_scene.queue_free()
	turn_on()

func _thread_load(path: String) -> void:
	var loader := ResourceLoader.load_interactive(path)
	assert(loader)
	var resource = null

	while true: #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread.
		var progress := float(loader.get_stage())/loader.get_stage_count()
		progress_bar.call_deferred("set_value", progress * 100)
		# Poll (does a load step).
		var err = loader.poll()
		# If OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if err == ERR_FILE_EOF:
			# Loading done, fetch resource.
			resource = loader.get_resource()
			break
		elif err != OK:
			# Not OK, there was an error.
			print("There was an error loading")
			break

	# Send whathever we did (or did not) get.
	call_deferred("_thread_done", resource)

func _thread_done(resource: PackedScene) -> void:
	assert(resource)

	# Always wait for threads to finish, this is required on Windows.
	thread.wait_to_finish()
	turn_off()

	# Instantiate new scene.
	var new_scene := resource.instance()
	# Add new one to root.
	get_tree().root.add_child(new_scene)
	# Set as current scene.
	get_tree().current_scene = new_scene

func turn_on() -> void:
	show()
	player.play("loading")

func turn_off() -> void:
	hide()
	player.stop(true)
