extends Node

@onready var terrain_map_layer: TileMapLayer = $TerrainMap
@onready var object_map_layer: TileMapLayer = $ObjectMap
@onready var border_map_layer: TileMapLayer = $BorderMap
@onready var player_on_map = $Playerr
@onready var bot_list: Array[Node] = [$Playerr2, $Playerr3, $Playerr4, $Enemy]
@onready var hp = $HP

var art: Vector2i
var port: Vector2i
var map_size:= Vector2i.ZERO
var cell_type_map: Dictionary[Vector2i,String]
var is_move: bool = true
const sand = Vector2i(4,9)
const water = Vector2i(5,9)
var json: Dictionary
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	##download map
	$HTTPRequest.request_completed.connect(_on_request_completed)
	
	## generate new map
	#$HTTPRequest.request("https://peak.e-dt.ru/maps/gen_map")
	
	## get map by num
	$HTTPRequest.request("https://peak.e-dt.ru/maps/get_map/2")
	
				
func _on_request_completed(result, response_code, headers, body):
	
	##json read
	json = JSON.parse_string(body.get_string_from_utf8())
	
	## for gen_map
	#reset_game(json["map"])
	
	## for get_map/2
	reset_game()
	
	
func reset_game() -> void:
	## global size map
	map_size.x = json["size"]["width"]
	map_size.y = json["size"]["height"]
	
	## clear all map layer
	terrain_map_layer.clear()
	object_map_layer.clear()
	border_map_layer.clear()
	
	## player start set pos
	player_on_map.is_art = false
	player_on_map.pos = Vector2i.ZERO
	var global_pos2 = terrain_map_layer.to_global(terrain_map_layer.map_to_local(player_on_map.pos))
	global_pos2.y -= 15
	player_on_map.global_position = global_pos2
	player_on_map.move(global_pos2)
	is_move = true
	refresh_hp()
	$Button2.hide()
	$Button.hide()
	
	for i in bot_list:
		i.refresh()
	
	## set start bot pos
	bot_list[0].pos = Vector2i(0, map_size.y-1)
	bot_list[1].pos = Vector2i(map_size.x-1, 0)
	bot_list[2].pos = Vector2i(map_size.x-1, map_size.y-1)
	
	## set start bot draw
	for i in 3:
		var global_pos = terrain_map_layer.to_global(terrain_map_layer.map_to_local(bot_list[i].pos))
		global_pos.y -= 15
		bot_list[i].hp = 2
		bot_list[i].global_position = global_pos
		bot_list[i].move(global_pos)
		bot_list[i].hide()
	
	## draw map
	for i in json["cells"]:
		cell_type_map.set(Vector2i(i["x"],i["y"]),i["cell_type"])
		
		## draw start cell
		if i["x"] == 0 && i["y"] == 0:
			if i["cell_type"] == "S":
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, sand)
			else:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, water)
				
				
		if (i["cell_items"].size() != 0):
			
			## enemy start set pos
			if (i["cell_items"][0] == "ANGRY_PERSON"):
				bot_list[3].pos = Vector2i(i["x"],i["y"])
				var global_pos = terrain_map_layer.to_global(terrain_map_layer.map_to_local(bot_list[3].pos))
				global_pos.y -= 15
				bot_list[3].global_position = global_pos
				bot_list[3].move(global_pos)
				bot_list[3].hide()
				
				## write pos portal and artifact
			elif (i["cell_items"][0] == "PORTAL"):
				port = Vector2i(i["x"],i["y"])
			elif (i["cell_items"][0] == "ARTIFACT"):
				art = Vector2i(i["x"],i["y"])
				
		## Отрисовка тумана
		if (player_on_map.pos != Vector2i(i["x"], i["y"])):
			if (i["x"] == map_size.x-1 && i["y"] == map_size.y-1):
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(3, 9))
			elif i["x"] == map_size.x-1:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(2, 9))
			elif i["y"] == map_size.y-1:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(1, 9))
			else:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(0, 9))
				
	## draw border
	reset_border()
	refresh_hp()
	
func set_is_move(l: bool) -> void:
	is_move = l
	if l:
		$Label.hide()
	else:
		$Label.show()
		

func reset_border() -> void:
	border_map_layer.clear()
	border_map_layer.set_cell(player_on_map.pos, 0, Vector2i(1, 13))
	if is_move:
		if player_on_map.pos.x + 1 < map_size.x:
			var pos = player_on_map.pos
			pos.x += 1
			border_map_layer.set_cell(pos, 0, Vector2i(1, 16))
		if player_on_map.pos.x - 1 > -1:
			var pos = player_on_map.pos
			pos.x -= 1
			border_map_layer.set_cell(pos, 0, Vector2i(1, 16))
		if player_on_map.pos.y + 1 < map_size.y:
			var pos = player_on_map.pos
			pos.y += 1
			border_map_layer.set_cell(pos, 0, Vector2i(1, 16))
		if player_on_map.pos.y - 1 > -1:
			var pos = player_on_map.pos
			pos.y -= 1
			border_map_layer.set_cell(pos, 0, Vector2i(1, 16))
		for i in bot_list:
			if i.is_alive:
				if abs(i.pos.x - player_on_map.pos.x) + abs(i.pos.y - player_on_map.pos.y) == 1:
					border_map_layer.set_cell(i.pos, 0, Vector2i(1, 14))
		
func refresh_hp() -> void:
	hp.refresh()
	
## сколько прибавить\убавить очков хп
func add_hp(num: int) -> void:
	hp.change_hp(num)
	
func move_bots() -> void:
	for i in bot_list.size():
		if bot_list[i].is_alive:
			var targets = scan_around(i)
			if targets.size() != 0:
				if randi()%2 == 0:
					bot_attack(targets[randi()%targets.size()],i)
					#print("bot"+str(i)+" select attack")
				else:
					bot_list[i].pos = get_randi_move(bot_list[i].pos)
					var global_pos = terrain_map_layer.to_global(terrain_map_layer.map_to_local(bot_list[i].pos))
					global_pos.y -= 15
					bot_list[i].move(global_pos)
					print("bot"+str(i)+" select move")
			else:
				bot_list[i].pos = get_randi_move(bot_list[i].pos)
				var global_pos = terrain_map_layer.to_global(terrain_map_layer.map_to_local(bot_list[i].pos))
				global_pos.y -= 15
				bot_list[i].move(global_pos)
				print("bot"+str(i)+" select move")
	bot_visible()
	set_is_move(true)
	reset_border()
	
func get_randi_move(unit_pos: Vector2i) -> Vector2i:
	var new_pos:= Vector2i.ZERO
	var count = 0
	while count < 100:
		var mob = Vector2i(randi()%3-1, randi()%3-1)
		if (abs(mob.x)+abs(mob.y)==1):
			new_pos = unit_pos + mob
			if (new_pos.x >-1 && new_pos.x < map_size.x && new_pos.y >-1 && new_pos.y < map_size.y):
				var n = 0
				for i in bot_list:
					if pos_check_contact(new_pos, i.pos):
						n += 1
				if pos_check_contact(new_pos, player_on_map.pos):
					n += 1
				if n == 5:
					return new_pos
		count += 1
	return unit_pos
	

func pos_check_contact(unit1: Vector2i, unit2: Vector2i) -> bool:
	if (unit1.x == unit2.x && unit1.y == unit2.y):
		return false
	else:
		return true

## show\hide bot
func bot_visible() -> void:
	for i in bot_list:
		if i.is_alive:
			if (abs(i.pos.x - player_on_map.pos.x) + abs(i.pos.y - player_on_map.pos.y) == 1):
				await get_tree().create_timer(0.3).timeout
				i.show()
			else: 
				if i.is_visible():
					await get_tree().create_timer(0.3).timeout
				i.hide()
			
			
func check_attack_player(target: Vector2i) -> bool:
	for i in bot_list:
		if i.is_alive:
			if i.pos == target:
				return false
	return true
	
func get_attack_bot_index(target: Vector2i) -> int:
	for i in bot_list.size():
		if bot_list[i].is_alive:
			if bot_list[i].pos == target:
				return i
	return -1
	
func bot_attack(target: int, attacker_id: int) -> void:
	if target == -1:
		player_on_map.set_damage_anim()
	else:
		bot_list[target].set_damage_anim()
	if attacker_id == -1:
		player_on_map.set_attack_anim()
	else:
		bot_list[attacker_id].set_attack_anim()
	if target == -1:
		add_hp(bot_list[attacker_id].dmg*-1)
	elif attacker_id == -1:
		bot_list[target].change_hp(player_on_map.dmg*-1)
	else:
		bot_list[target].change_hp(bot_list[attacker_id].dmg*-1)
	print("unit "+ str(attacker_id)+ " attack "+str(target))
	await get_tree().create_timer(1.0).timeout
	
	
func scan_around(index: int) -> Array[int]:
	var targets: Array[int]
	if index != -1:
		if (abs(bot_list[index].pos.x - player_on_map.pos.x) + abs(bot_list[index].pos.y - player_on_map.pos.y) == 1):
			targets.append(-1)
	for i in bot_list.size():
		if i != index:
			if (abs(bot_list[index].pos.x - bot_list[i].pos.x) + abs(bot_list[index].pos.y - bot_list[i].pos.y) == 1):
				targets.append(i)
	return targets
	
func player_attack(id_bot: int) -> void:
	bot_list[id_bot].set_damage_anim()
	player_on_map.set_attack_anim()
	bot_list[id_bot].change_hp(player_on_map.dmg*-1)
	print(str(id_bot)+": "+ str(bot_list[id_bot].hp))
	await get_tree().create_timer(1.4).timeout
	reset_border()
	move_bots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_move:
		if Input.is_action_just_pressed("move_on_click"):
			var cell_cord = terrain_map_layer.local_to_map(terrain_map_layer.get_local_mouse_position())
			print(cell_cord)
			
			## check move player
			if (abs(cell_cord.x - player_on_map.pos.x) + abs(cell_cord.y - player_on_map.pos.y) == 1):
				if check_attack_player(cell_cord):
					if (cell_cord.x > -1 && cell_cord.x < map_size.x && cell_cord.y > -1 && cell_cord.y < map_size.y):
						set_is_move(false)
						player_on_map.pos = cell_cord
						
						## draw open cell
						terrain_map_layer.erase_cell(cell_cord)
						if cell_type_map.get(cell_cord) == "S":
							terrain_map_layer.set_cell(cell_cord, 0, sand)
						else:
							terrain_map_layer.set_cell(cell_cord, 0, water)
						reset_border()
						
						## move player
						var cell_pos_global = terrain_map_layer.to_global(terrain_map_layer.map_to_local(cell_cord))
						#print(cell_pos_global)
						print("player move")
						cell_pos_global.y -= 15
						player_on_map.move(Vector2(float(cell_pos_global.x), float(cell_pos_global.y)))
						
						bot_visible()
						
						## check artifact
						var mod_art = cell_cord - art
						if (abs(mod_art.x)+abs(mod_art.y)==1 && player_on_map.is_art == false):
							object_map_layer.set_cell(Vector2i(art), 1, Vector2i.ZERO)
						if (cell_cord == art && player_on_map.is_art == false):
							player_on_map.is_art = true
							print("art")
							object_map_layer.erase_cell(art)
							
						## check portal
						var mod_port = cell_cord - port
						if (abs(mod_port.x)+abs(mod_port.y)==1):
							object_map_layer.set_cell(Vector2i(port), 0, Vector2i.ZERO)
						if (cell_cord == port && player_on_map.is_art):
							print("port")
							is_move = false
							border_map_layer.clear()
							border_map_layer.set_cell(player_on_map.pos, 0, Vector2i(1,13))
							$Button2.show()
							
						await get_tree().create_timer(1.0).timeout
						
						## move all bot
						move_bots()
				else:
					set_is_move(false)
					bot_attack(get_attack_bot_index(cell_cord), -1)
					await get_tree().create_timer(1.0).timeout
					reset_border()
					move_bots()
