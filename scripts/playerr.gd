extends CharacterBody2D

const SPEED = 100.0
@onready var target = position
@onready var anim = $AnimatedSprite2D
var pos:= Vector2i.ZERO
var is_art = false
var hp = 2
var dmg = 1
var is_alive = true
var up_pos: int = 20

func refresh() -> void:
	hp = 2
	dmg = 1
	is_art = false
	is_alive = true
	pos = Vector2i.ZERO
	
func _ready() -> void:
	set_idle_anim()
	
func set_global_pos(pos: Vector2) -> void:
	pos.y -= up_pos
	global_position = pos

func move(new_pos: Vector2) -> void:
	new_pos.y -= up_pos
	target = new_pos

func set_attack_anim() -> void:
	anim.play("attack")
	
func set_damage_anim() -> void:
	anim.play("damage")
	
func set_idle_anim() -> void:
	anim.play("idle")
	
func change_hp(num: int) -> void:
	if is_alive:
		hp += num
		if hp < 0:
			dead_unit()
			
func dead_unit() -> void:
	pos = Vector2i(-1,-1)
	is_alive = false
	print("bot_dead")
	await get_tree().create_timer(0.9).timeout
	hide()
	
	

func _physics_process(delta: float) -> void:
	if is_alive:
		velocity = position.direction_to(target) * SPEED
		
		if position.distance_to(target) > 2:
			move_and_slide()
