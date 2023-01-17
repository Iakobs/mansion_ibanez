extends Control

onready var progress_bar: ProgressBar = $"%ProgressBar"

var thread: Thread

func _ready() -> void:
	hide()

func load_scene(path: String) -> void:
	thread = Thread.new()
	var _error := thread.start( self, "_thread_load", path)
	get_tree().current_scene.queue_free()
	show()

func _thread_load(path: String) -> void:
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	var total = ril.get_stage_count()
	# Call deferred to configure max load steps.
	progress_bar.call_deferred("set_max", total)

	var res = null

	while true: #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread.
		progress_bar.call_deferred("set_value", ril.get_stage())
		# Poll (does a load step).
		var err = ril.poll()
		# If OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if err == ERR_FILE_EOF:
			# Loading done, fetch resource.
			res = ril.get_resource()
			break
		elif err != OK:
			# Not OK, there was an error.
			print("There was an error loading")
			break

	# Send whathever we did (or did not) get.
	call_deferred("_thread_done", res)


func _thread_done(resource: Resource) -> void:
	assert(resource)

	# Always wait for threads to finish, this is required on Windows.
	thread.wait_to_finish()
	hide()

	# Instantiate new scene.
	var new_scene = resource.instance()
	# Add new one to root.
	get_tree().root.add_child(new_scene)
	# Set as current scene.
	get_tree().current_scene = new_scene
