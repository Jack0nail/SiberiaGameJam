extends CharacterBody2D

const SPEED = 80.0
@onready var target = position
var pos:= Vector2i.ZERO
var is_art = false


func move(new_pos: Vector2) -> void:
	target = new_pos

func _physics_process(delta: float) -> void:
	#print(position)
	#print(target)
	velocity = position.direction_to(target) * SPEED
	
	if position.distance_to(target) > 2:
		move_and_slide()
