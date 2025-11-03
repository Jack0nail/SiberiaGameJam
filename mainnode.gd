extends Node

@onready var terrain_map_layer: TileMapLayer = $TerrainMap
@onready var object_map_layer: TileMapLayer = $ObjectMap
@onready var fart_map_layer: TileMapLayer = $FartMap
@onready var monster_map_layer: TileMapLayer = $MonsterMap
@onready var player_map_layer: TileMapLayer = $PlayerMap
#var xp = 0
#var yp = 0
var player
var monster
var xmap = 0
var ymap = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for y in 15:
		#for x in 15:
			#terrain_map_layer.set_cell(Vector2i(x, y), 2, Vector2i(randi() % 21, 0))
	#player_map_layer.set_cell(Vector2i(0, 0), 1, Vector2i(0, 0))
	##player_map_layer.set_cell(Vector2i(0, 9), 1, Vector2i(0, 0))
	##player_map_layer.set_cell(Vector2i(9, 0), 1, Vector2i(0, 0))
	##player_map_layer.set_cell(Vector2i(9, 9), 1, Vector2i(0, 0))
	#
	#
	#for y in 10:
		#for x in 10:
			#if (player_map_layer.get_cell_source_id(Vector2i(x, y)) == -1):
				#if (x == 9 || y == 9):
					#fart_map_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
				#else:
					#fart_map_layer.set_cell(Vector2i(x, y), 1, Vector2i(0, 0))
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("http://147.45.219.226/maps/get_map/2")
				
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	xmap = json["size"]["width"]
	ymap = json["size"]["height"]
	player = Entity.new(Vector2i(0,0))
	player_map_layer.set_cell(player.pos, 1, Vector2i(0, 0))
	for i in json["cells"]:
		var a
		if (i["cell_type"] == "S"):
			a = 20
		else:
			a = 20
		if (i["cell_items"].size() != 0):
			if (i["cell_items"][0] == "ANGRY_PERSON"):
				monster = Entity.new(Vector2i(i["x"],i["y"]))
		terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 2, Vector2i(a, 0))
		if (player_map_layer.get_cell_source_id(Vector2i(i["x"], i["y"])) == -1):
			if (i["x"] == xmap-1 || i["y"] == ymap-1):
				fart_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(0, 0))
			else:
				fart_map_layer.set_cell(Vector2i(i["x"], i["y"]), 1, Vector2i(0, 0))
	
	
func _on_button_up_pressed() -> void:
		move_player(-1,0)
	
func _on_button_left_pressed() -> void:
		move_player(0,1)
		
func _on_button_right_pressed() -> void:
	move_player(0,-1)
	
func _on_button_down_pressed() -> void:
	move_player(1,0)

#func _on_button_up_right_pressed() -> void:
	#move_player(-1,-1)
#
#func _on_button_right_up_pressed() -> void:
	#move_player(1,-1)
#
#func _on_button_down_left_pressed() -> void:
	#move_player(1,1)
#
#func _on_button_left_down_pressed() -> void:
	#move_player(-1,1)
	
func move_player(x:int, y:int) -> void:
	if (player.pos.x+x<10 && player.pos.x+x>-1 && player.pos.y+y<10 && player.pos.y+y>-1):
		player_map_layer.erase_cell(player.pos)
		player.pos.x += x
		player.pos.y += y
		player_map_layer.set_cell(player.pos, 1, Vector2i(0, 0))
		fart_map_layer.erase_cell(player.pos)
		#_rannum()
		move_monster()
		monster_brain()
		
func move_monster():
	var x = randi()%3-1
	var y = randi()%3-1  
	if (monster.pos.x+x<10 && monster.pos.x+x>-1 && monster.pos.y+y<10 && monster.pos.y+y>-1):
			monster_map_layer.erase_cell(monster.pos)
			monster.pos.x +=x
			monster.pos.y +=y
			monster_map_layer.set_cell(monster.pos, 0, Vector2i(0, 0))
	else: move_monster()
func monster_brain():
	monster_hide()
	
func monster_hide():
	if (monster.pos.x - player.pos.x >=-1 && monster.pos.x - player.pos.x <=1 && monster.pos.y - player.pos.y >=-1 && monster.pos.y - player.pos.y <=1):
		monster_map_layer.show()
	else: monster_map_layer.hide()
func monster_chase():
	if (monster.pos.x - player.pos.x >=-1 && monster.pos.x - player.pos.x <=1 && monster.pos.y - player.pos.y >=-1 && monster.pos.y - player.pos.y <=1):
		player.pos


#func move_player(x:int, y:int) -> void:
	#if (player.pos.x+x<10 || player.pos.x+x>-1 || player.pos.y+y<10 || player.pos.y+y>-1):
		#player_map_layer.erase_cell(player.pos)
		#player.pos.x += x
		#player.pos.y += y
		#player_map_layer.set_cell(player.pos, 1, Vector2i(0, 0))
		#fart_map_layer.erase_cell(player.pos)
		#func _on_button_up_pressed() -> void:
  #if (player.pos.x-1>-1):
	#player_map_layer.erase_cell(player.pos)
	#player.pos.x -= 1
	#player_map_layer.set_cell(player.pos,1,Vector2i(0,0))
	#fart_map_layer.erase_cell(player.pos)

#func _on_button_up_pressed() -> void:
	#if (xp-1>-1):
		#player_map_layer.erase_cell(Vector2i(xp, yp))
		#xp-=1
		#player_map_layer.set_cell(Vector2i(xp, yp), 1, Vector2i(0, 0))
		#fart_map_layer.erase_cell(Vector2i(xp, yp))
	#
#func _on_button_left_pressed() -> void:
	#if (yp+1<ymap):
		#player_map_layer.erase_cell(Vector2i(xp, yp))
		#yp+=1
		#player_map_layer.set_cell(Vector2i(xp, yp), 1, Vector2i(0, 0))
		#fart_map_layer.erase_cell(Vector2i(xp, yp))
		#
	#
#func _on_button_right_pressed() -> void:
	#if (yp-1>-1):
		#player_map_layer.erase_cell(Vector2i(xp, yp))
		#yp-=1
		#player_map_layer.set_cell(Vector2i(xp, yp), 1, Vector2i(0, 0))
		#fart_map_layer.erase_cell(Vector2i(xp, yp))
	#
#func _on_button_down_pressed() -> void:
	#if (xp+1<xmap):
		#player_map_layer.erase_cell(Vector2i(xp, yp))
		#xp+=1
		#player_map_layer.set_cell(Vector2i(xp, yp), 1, Vector2i(0, 0))
		#fart_map_layer.erase_cell(Vector2i(xp, yp))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
