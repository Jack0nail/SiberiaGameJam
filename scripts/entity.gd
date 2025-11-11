extends Node

class_name Entity

var pos: Vector2i
const speed: int = 50

func _init(coord: Vector2i) -> void:
	pos = coord
