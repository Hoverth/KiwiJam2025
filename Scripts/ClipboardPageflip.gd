extends Node2D

@export var images: Array[Texture2D]

var current_page := 0

func _process(delta: float) -> void:
	$Image.texture = images[current_page]
	$Left.visible = current_page > 0
	$Right.visible = current_page + 1 < len(images)

func right() -> void:
	print("right")
	if current_page + 1 < len(images):
		print("righet")
		current_page += 1

func left() -> void:
	print('left')
	if current_page > 0:
		print('lke')
		current_page -= 1
