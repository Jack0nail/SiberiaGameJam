extends Node

@onready var terrain_map_layer: TileMapLayer = $TerrainMap
@onready var object_map_layer: TileMapLayer = $ObjectMap
@onready var fart_map_layer: TileMapLayer = $FartMap
@onready var border_map_layer: TileMapLayer = $BorderMap
@onready var player_on_map = $Playerr

var xmap = 0
var ymap = 0
var cell_type_map: Dictionary[Vector2i,String]
var is_move: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HTTPRequest2.request_completed.connect(_on_request_completed)
	$HTTPRequest2.request("https://peak.e-dt.ru/maps/get_map/2")
				
#func _on_request_id_completed(result, response_code, headers, body):
	#$HTTPRequest.request_completed.connect(_on_request_completed)
	#var json = JSON.parse_string(body.get_string_from_utf8())
	#var id: int = json["id"]
	#$HTTPRequest.request("https://peak.e-dt.ru/maps/get_map/"+str(id))
				
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	xmap = json["size"]["width"]
	ymap = json["size"]["height"]
	for i in json["cells"]:
		var a
		cell_type_map.set(Vector2i(i["x"],i["y"]),i["cell_type"])
		if (i["cell_type"] == "S"):
			a = 4
		else:
			a = 1
		if (i["cell_items"].size() != 0):
			if (i["cell_items"][0] == "ANGRY_PERSON"):
				#monster = Entity.new(Vector2i(i["x"],i["y"]))
				pass
		terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 3, Vector2i(a, 0))
		if (player_on_map.pos == Vector2i(i["x"], i["y"])):
			if (i["x"] == xmap-1 || i["y"] == ymap-1):
				fart_map_layer.set_cell(Vector2i(i["x"], i["y"]), 2, Vector2i(3, 0))
			else:
				fart_map_layer.set_cell(Vector2i(i["x"], i["y"]), 2, Vector2i(3, 0))
	fart_map_layer.erase_cell(Vector2i.ZERO)
	reset_border(player_on_map.pos)
	
	
func _on_button_up_pressed() -> void:
		move_player(-1,0)
	
func _on_button_left_pressed() -> void:
		move_player(0,1)
		
func _on_button_right_pressed() -> void:
	move_player(0,-1)
	
func _on_button_down_pressed() -> void:
	move_player(1,0)
	
func move_player(x:int, y:int) -> void:
		#_rannum()
		move_monster()
		monster_brain()
		
func move_monster():
	var x = randi()%3-1
	var y = randi()%3-1  
	#if (monster.pos.x+x<10 && monster.pos.x+x>-1 && monster.pos.y+y<10 && monster.pos.y+y>-1):
			#monster_map_layer.erase_cell(monster.pos)
			#monster.pos.x +=x
			#monster.pos.y +=y
			#monster_map_layer.set_cell(monster.pos, 0, Vector2i(0, 0))
	#else: move_monster()
	
func monster_brain():
	monster_hide()
	
func monster_hide():
	#if (monster.pos.x - player.pos.x >=-1 && monster.pos.x - player.pos.x <=1 && monster.pos.y - player.pos.y >=-1 && monster.pos.y - player.pos.y <=1):
		#monster_map_layer.show()
	#else: monster_map_layer.hide()
	pass
func monster_chase():
	#if (monster.pos.x - player.pos.x >=-1 && monster.pos.x - player.pos.x <=1 && monster.pos.y - player.pos.y >=-1 && monster.pos.y - player.pos.y <=1):
		#player.pos
		pass

func reset_border(coodr: Vector2i) -> void:
	border_map_layer.clear()
	border_map_layer.set_cell(coodr, 0, Vector2i(1,0))
	if player_on_map.pos.x + 1 < xmap:
		var pos = coodr
		pos.x+=1
		border_map_layer.set_cell(pos, 0, Vector2i(1,3))
	if player_on_map.pos.x - 1 > -1:
		var pos = coodr
		pos.x-=1
		border_map_layer.set_cell(pos, 0, Vector2i(1,3))
	if player_on_map.pos.y + 1 < ymap:
		var pos = coodr
		pos.y+=1
		border_map_layer.set_cell(pos, 0, Vector2i(1,3))
	if player_on_map.pos.y - 1 > -1:
		var pos = coodr
		pos.y-=1
		border_map_layer.set_cell(pos, 0, Vector2i(1,3))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_move:
		if Input.is_action_just_pressed("move_on_click"):
			var cell_cord =terrain_map_layer.local_to_map(terrain_map_layer.get_local_mouse_position())
			print(cell_cord)
			var mod = cell_cord-player_on_map.pos
			#print(player_on_map.pos+mod)
			if (abs(mod.x)+abs(mod.y)==1):
				if (cell_cord.x >-1 && cell_cord.x < xmap && cell_cord.y >-1 && cell_cord.y < ymap):
					player_on_map.pos = cell_cord
					fart_map_layer.erase_cell(cell_cord)
					reset_border(cell_cord)
					var cell_pos_global = terrain_map_layer.to_global(terrain_map_layer.map_to_local(cell_cord))
					#print(cell_pos_global)
					print("hui")
					cell_pos_global.y -= 15
					player_on_map.move(Vector2(float(cell_pos_global.x), float(cell_pos_global.y)))
