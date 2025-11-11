extends Node2D

@onready var array_hp: Array[Node] = [$HP1, $HP2, $HP3, $HP4, $HP5]
var num_hp = 2
var cur_num = 0
var last_change = 2
var is_not_anim = true
var is_not_game_over = true

## clear change
func refresh() -> void:
	num_hp = 2
	cur_num = 0
	last_change = 2 
	is_not_game_over = true
	array_hp[0].play("up")
	array_hp[1].play("up")
	array_hp[2].play("up")
	array_hp[3].hide()
	array_hp[4].hide()
	
func change_hp(num: int) -> void:
	cur_num += num
	if is_not_anim:
		reset_hp()
	
func _anim_finish() -> void:
	if last_change == 3 || last_change == 4:
		if array_hp[last_change].get_animation() == "down":
			array_hp[last_change].hide()
	reset_hp()

func reset_hp() -> void:
	if is_not_game_over:
		if cur_num > 0:
			
			## hp increase
			if num_hp + 1 < 5:
				is_not_anim = false
				num_hp += 1
				cur_num -= 1
				last_change = num_hp
				array_hp[num_hp].play("up")
				if last_change == 3 || last_change == 4:
					array_hp[last_change].show()
			else:
				is_not_anim = true
				cur_num = 0
			
		elif cur_num < 0:
			
			## hp decrease
			if num_hp - 1 > -1:
				is_not_anim = false
				last_change = num_hp
				array_hp[num_hp].play("down")
				num_hp -= 1
				cur_num += 1
			elif num_hp - 1 == -1:
				
				## game over
				is_not_game_over = false
				array_hp[num_hp].play("down")
				num_hp-=1
				$"../Button".show()
				
		## not change
		else:
			is_not_anim = true
			cur_num = 0
