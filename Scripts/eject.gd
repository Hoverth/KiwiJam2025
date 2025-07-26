extends Node2D

var seat_list = ['E3', 'D4', 'A9', 'Q2']
var seat_index = 0
var target_seat: String
var rng = RandomNumberGenerator.new()
@onready var seat_label = $SeatLabel

func _ready():
	var target_int = rng.randf_range(0, 3)
	target_seat = seat_list[target_int]
	seat_label.text = seat_list[seat_index]
	
func _on_up_button_pressed() -> void:
	if seat_index > 0:
		seat_index -= 1
		seat_label.text = seat_list[seat_index]

func _on_down_button_pressed() -> void:
	if seat_index < 3:
		seat_index += 1
		seat_label.text = seat_list[seat_index]

func _on_eject_button_pressed() -> void:
	if target_seat == seat_list[seat_index]:
		print('ejected the target seat')
		print(target_seat)
	else:
		print('ejected wrong seat')
		print(target_seat)
