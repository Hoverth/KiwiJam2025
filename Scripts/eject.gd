extends Node2D

var seat_list := [
	'A1',
	'A2',
	'B1',
	'B2',
	'C3',
	'D3',
	'D4',
	'E1',
	'Q2'
]

var passenger_list := [
	'Ronald Sump',
	'Boe Jiden',
	'Joey JoJo Junior Shabadoo',
	'Big Dave',
	'Lim Knee',
	'Keight Cheggers Chegwin',
	'Gary',
	'Abhijit Naskar',
	'Bob Ross'
]

var color_mapping := {
	'A1': ['b', 'b', 'b'],
	'A2': ['b', 'b', 'r'],
	'B1': ['y', 'g', 'y'],
	'B2': ['g', 'g', 'y'],
	'C3': ['r', 'r', 'g'],
	'D3': ['r', 'g', 'r'],
	'D4': ['r', 'r', 'r'],
	'E1': ['b', 'g', 'g'],
	'Q2': ['b', 'r', 'g']
}
var seat_index = 0
var target_seat: String
var target_code: Array[String] = []
@onready var seat_label = $SeatLabel
@onready var overweight_alert = $"../Overweight Alert"
@onready var flush = $"../Flush Sound"

@export var min_eject_challenge_delay := 20.0
@export var max_eject_challenge_delay := 45.0
@export var timeToDeath :int = 30
var eventActive
func reset(wait_first: bool = true) -> void:
	if wait_first:
		await get_tree().create_timer(randf_range(min_eject_challenge_delay, max_eject_challenge_delay)).timeout
	startDeathTimer()
	target_seat = seat_list.pick_random()
	print(target_seat)
	print(color_mapping.get(target_seat))
	target_code.assign(color_mapping.get(target_seat))
	eventActive = true
	overweight_alert.play()

func startDeathTimer():
	$EjectDeathTimer.stop()
	$EjectDeathTimer.wait_time = timeToDeath
	$EjectDeathTimer.start()
	

func _on_eject_death_timer_timeout() -> void:
	if(eventActive):
		var gameManager :Game = get_tree().root.get_node("Game")
		gameManager.gameOver("The pilot did not eject the right person on time.")
	pass
func _process(delta: float) -> void:
	if not $AnimationPlayer.current_animation:
		for c in target_code:
			$AnimationPlayer.queue("flash_" + c)
		$AnimationPlayer.queue("flash_blank")

func _on_up_button_pressed() -> void:
	if $"..".control_enabled and seat_index > 0:
		seat_index -= 1
		seat_label.text = seat_list[seat_index]

func _on_down_button_pressed() -> void:
	if $"..".control_enabled and seat_index + 1 < len(seat_list):
		seat_index += 1
		seat_label.text = seat_list[seat_index]

func _on_eject_button_pressed() -> void:
	if $"..".control_enabled and target_seat == seat_list[seat_index]:
		print('ejected the target seat')
		print(target_seat)
		target_code = []
		var gameManager :Game = get_tree().root.get_node("Game")
		eventActive = false
		gameManager.eventRunning = false
		gameManager.eventTimer()
		$EjectDeathTimer.stop()
		overweight_alert.stop()
		flush.play()
	elif $"..".control_enabled:
		
		var person : String = passenger_list[seat_index]
		
		var fine : int = randi_range(300,950)
		
		var gameManager :Game = get_tree().root.get_node("Game")
		
		var format = "You have gotten sued by the family of %s for \n wrongful ejection.\n\n\nYou have also been fined %d million dollars by the NZ Civil & Aviation Authority."
		
		gameManager.gameOver(format % [person,fine])
		print(target_seat)
