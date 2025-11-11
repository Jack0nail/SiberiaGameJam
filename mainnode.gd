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
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	## for gen_map
	#reset_game(json["map"])
	
	## for get_map/2
	reset_game(json)
	
	
func reset_game(json: Dictionary) -> void:
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
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(4,9))
			else:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(1,9))
				
				
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
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 1, Vector2i(3, 0))
			elif i["x"] == map_size.x-1:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 1, Vector2i(2, 0))
			elif i["y"] == map_size.y-1:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 1, Vector2i(1, 0))
			else:
				terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 1, Vector2i(0, 0))
				
	## draw border
	reset_border(player_on_map.pos)
	refresh_hp()

func reset_border(coodr: Vector2i) -> void:
	border_map_layer.clear()
	border_map_layer.set_cell(coodr, 0, Vector2i(1,13))
	if player_on_map.pos.x + 1 < map_size.x:
		var pos = coodr
		pos.x += 1
		border_map_layer.set_cell(pos, 0, Vector2i(1,16))
	if player_on_map.pos.x - 1 > -1:
		var pos = coodr
		pos.x -= 1
		border_map_layer.set_cell(pos, 0, Vector2i(1,16))
	if player_on_map.pos.y + 1 < map_size.y:
		var pos = coodr
		pos.y += 1
		border_map_layer.set_cell(pos, 0, Vector2i(1,16))
	if player_on_map.pos.y - 1 > -1:
		var pos = coodr
		pos.y -= 1
		border_map_layer.set_cell(pos, 0, Vector2i(1,16))
		
func _hp_down() -> void:
	hp.change_hp(-2)
	
func _hp_down_1() -> void:
	hp.change_hp(-1)
	
func _hp_up() -> void:
	hp.change_hp(2)
	
func _hp_up_1() -> void:
	hp.change_hp(1)
	
func refresh_hp() -> void:
	hp.refresh()
	
## сколько прибавить\убавить очков хп
func add_hp(num: int) -> void:
	hp.change_hp(num)
	
func get_randi_move(unit_pos: Vector2i) -> Vector2i:
	var new_pos:= Vector2i.ZERO
	while true:
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
					break
	return new_pos
	

func pos_check_contact(unit1: Vector2i, unit2: Vector2i) -> bool:
	if (unit1.x == unit2.x && unit1.y == unit2.y):
		return false
	else:
		return true

func bot_visible() -> void:
	for i in bot_list:
		if (abs(i.pos.x - player_on_map.pos.x) + abs(i.pos.y - player_on_map.pos.y) == 1):
			i.show()
		else: 
			i.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_move:
		if Input.is_action_just_pressed("move_on_click"):
			var cell_cord =terrain_map_layer.local_to_map(terrain_map_layer.get_local_mouse_position())
			print(cell_cord)
			var mod = cell_cord-player_on_map.pos
			#print(player_on_map.pos+mod)
			
			## check move player
			if (abs(mod.x)+abs(mod.y)==1):
				if (cell_cord.x >-1 && cell_cord.x < map_size.x && cell_cord.y >-1 && cell_cord.y < map_size.y):
					player_on_map.pos = cell_cord
					
					## draw open cell
					terrain_map_layer.erase_cell(cell_cord)
					if cell_type_map.get(cell_cord) == "S":
						terrain_map_layer.set_cell(cell_cord, 0, Vector2i(4,9))
					else:
						terrain_map_layer.set_cell(cell_cord, 0, Vector2i(1,9))
					reset_border(cell_cord)
					
					## move player
					var cell_pos_global = terrain_map_layer.to_global(terrain_map_layer.map_to_local(cell_cord))
					#print(cell_pos_global)
					print("hui")
					cell_pos_global.y -= 15
					player_on_map.move(Vector2(float(cell_pos_global.x), float(cell_pos_global.y)))
					
					bot_visible()
					
					## check artifact
					var mod_art = cell_cord - art
					if (abs(mod_art.x)+abs(mod_art.y)==1 && player_on_map.is_art == false):
						object_map_layer.set_cell(Vector2i(art), 0, Vector2i(0, 10))
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
						$Label.show()
						
					for i in bot_list:
						i.pos = get_randi_move(i.pos)
						var global_pos = terrain_map_layer.to_global(terrain_map_layer.map_to_local(i.pos))
						global_pos.y -= 15
						i.move(global_pos)
						bot_visible()
							
