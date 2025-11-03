extends Node

class_name Entity

var pos: Vector2i
var ocherednum: int

func _init(coord: Vector2i, ochered: int) -> void:
	pos = coord
	ocherednum = ochered
