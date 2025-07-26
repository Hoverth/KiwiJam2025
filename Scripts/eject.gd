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

func startDeathTimer():
	await get_tree().create_timer(timeToDeath).timeout
	if(eventActive):
		var gameManager :Game = get_tree().root.get_node("Game")
		print("Ran out of time on light minigame")
		gameManager.gameOver()

func _process(delta: float) -> void:
	if not $AnimationPlayer.current_animation:
		for c in target_code:
			$AnimationPlayer.queue("flash_" + c)
		$AnimationPlayer.queue("flash_blank")

func _on_up_button_pressed() -> void:
	if seat_index > 0:
		seat_index -= 1
		seat_label.text = seat_list[seat_index]

func _on_down_button_pressed() -> void:
	if seat_index + 1 < len(seat_list):
		seat_index += 1
		seat_label.text = seat_list[seat_index]

func _on_eject_button_pressed() -> void:
	if target_seat == seat_list[seat_index]:
		print('ejected the target seat')
		print(target_seat)
		target_code = []
		var gameManager :Game = get_tree().root.get_node("Game")
		eventActive = false
		gameManager.eventRunning = false
		gameManager.eventTimer()
	else:
		print('ejected wrong seat')
		var gameManager :Game = get_tree().root.get_node("Game")
		gameManager.gameOver()
		print(target_seat)
