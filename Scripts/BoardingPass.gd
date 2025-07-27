extends Control

func _on_name_text_changed(new_text: String) -> void:
	$nameLabel.text = new_text


func _on_room_code_text_changed(new_text: String) -> void:
	var col = $roomCode.caret_column
	$roomCode.text = new_text.to_upper()
	$roomCode.caret_column = col
	$roomLabel.text = new_text.to_upper()
