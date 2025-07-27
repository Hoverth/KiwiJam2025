extends Control

func _on_name_text_changed(new_text: String) -> void:
	$nameLabel.text = new_text


func _on_room_code_text_changed(new_text: String) -> void:
	$roomCode.text = new_text.to_upper()
	$roomCode.caret_column = len(new_text)
	$roomLabel.text = new_text.to_upper()
