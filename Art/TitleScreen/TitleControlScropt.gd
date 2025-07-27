extends Node2D

@export var delay_presenting_text_ms: int = 2900
@export var delay_show_presents_ms: int = 6800
@export var delay_presenting_screen_ms: int = 11300
@export var delay_logo_ms: int = 14400

var start_time: int

@export var game_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_ticks_msec()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var t = Time.get_ticks_msec()
	if start_time + delay_presenting_text_ms < t:
		$Presenting/ThuliferousPresents.visible = true
	if start_time + delay_show_presents_ms < t:
		$Presenting/ThuliferousPresents.animation = "presents"
	if start_time + delay_presenting_screen_ms < t:
		$Presenting.visible = false
	if start_time + delay_logo_ms < t:
		$Title/LandordTitlteText.visible = true
		$Title/LandlordParticles.amount = 100
		if Input.is_action_just_pressed("left_click"):
			# ready to go to next scene
			get_tree().change_scene_to_packed(game_scene)
