extends Sprite2D

var bird := preload("res://Scenes/Controller/BirdStrike.tscn")
@export var spawn_radius := 500.0
@export var min_spawn_delay := 5.0
@export var max_spawn_delay := 8.0

signal game_over

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if get_rect().has_point(to_local(event.position)):
			var point_vec: Vector2 = event.position - $PlayerPlane.global_position
			var rot := atan2(point_vec.y, point_vec.x)
			print(rot)
			$PlayerPlane/Sprite2D.rotation = rot

func _on_timer_timeout() -> void:
	var inst := bird.instantiate()
	var random_angle := randf() * TAU
	inst.position = Vector2.from_angle(random_angle) * spawn_radius
	$Birds.add_child(inst)
	$Timer.start(randf_range(min_spawn_delay, max_spawn_delay))

func _on_player_plane_area_entered(area: Area2D) -> void:
	game_over.emit()
