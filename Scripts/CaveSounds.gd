extends AudioStreamPlayer

@export var cave_sounds: Array[AudioStream]

@export var cave_sounds_wait_min := 10.0
@export var cave_sounds_wait_max := 30.0

func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	stop()
	stream = cave_sounds.pick_random()
	if stream:
		play()
	$Timer.start(randf_range(cave_sounds_wait_min, cave_sounds_wait_max))
