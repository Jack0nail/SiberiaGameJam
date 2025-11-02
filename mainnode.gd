extends Node

@onready var terrain_map_layer: TileMapLayer = $TerrainMap
@onready var object_map_layer: TileMapLayer = $ObjectMap
@onready var fart_map_layer: TileMapLayer = $FartMap
@onready var player_map_layer: TileMapLayer = $PlayerMap
@onready var monster_map_layer: TileMapLayer = $monsterMap

var player_entity 
var monster_entity

func _ready() -> void:
	
	for y in 10:
		for x in 10:
			terrain_map_layer.set_cell(Vector2i(x, y), 0, Vector2i(randi() % 18, 0))
	monster_entity = Entity.new(Vector2i(randi()%8+1,randi()%8+1))
	monster_map_layer.set_cell(monster_entity.pos, 0, Vector2i(0, 0))
	player_map_layer.set_cell(Vector2i(0, 0), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(0,0)))
	player_map_layer.set_cell(Vector2i(0, 9), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(0,9)))
	player_map_layer.set_cell(Vector2i(9, 0), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(9,0)))
	player_map_layer.set_cell(Vector2i(9, 9), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(9,9)))
	monster_map_layer.hide()

	
	
	for y in 10:
		for x in 10:
			if (player_entity.pos != Vector2i(x,y)):
				if (x == 9 || y == 9):
					fart_map_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
				else:
					fart_map_layer.set_cell(Vector2i(x, y), 1, Vector2i(0, 0))
				
func _on_button_up_pressed() -> void:
		move_player(-1,0)
	
func _on_button_left_pressed() -> void:
		move_player(0,1)
		
func _on_button_right_pressed() -> void:
	move_player(0,-1)
	
func _on_button_down_pressed() -> void:
	move_player(1,0)

func _on_button_up_right_pressed() -> void:
	move_player(-1,-1)

func _on_button_right_up_pressed() -> void:
	move_player(1,-1)

func _on_button_down_left_pressed() -> void:
	move_player(1,1)

func _on_button_left_down_pressed() -> void:
	move_player(-1,1)

func _on_button_pressed() -> void:
	$BoxContainer.hide()

func _on_button_2_pressed() -> void:
	$BoxContainer.hide()

func _rannum():
	if (randi()%100+1) <= 20:
		$BoxContainer.show()
		
	var numran = randi()%10 
	match numran:
		0:
			$BoxContainer/head.set("text","test 0")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		1:
			$BoxContainer/head.set("text","test 1")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		2:
			$BoxContainer/head.set("text","test 2")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		3:
			$BoxContainer/head.set("text","test 3")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		4:
			$BoxContainer/head.set("text","test 4")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		5:
			$BoxContainer/head.set("text","test 5")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		6:
			$BoxContainer/head.set("text","test 6")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		7:
			$BoxContainer/head.set("text","test 7")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		8:
			$BoxContainer/head.set("text","test 8")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
		9:
			$BoxContainer/head.set("text","test 9")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			$BoxContainer/Control2/Button.set("text","sosal")
			$BoxContainer/Control2/Button2.set("text","ebali")
func move_player(x:int, y:int) -> void:
	if (player_entity.pos.x+x<10 && player_entity.pos.x+x>-1 && player_entity.pos.y+y<10 && player_entity.pos.y+y>-1):
		player_map_layer.erase_cell(player_entity.pos)
		player_entity.pos.x += x
		player_entity.pos.y += y
		player_map_layer.set_cell(player_entity.pos, 1, Vector2i(0, 0))
		fart_map_layer.erase_cell(player_entity.pos)
		#_rannum()
		move_monster()
		monster_brain()
		
func move_monster():
	var x = randi()%3-1
	var y = randi()%3-1  
	if (monster_entity.pos.x+x<10 && monster_entity.pos.x+x>-1 && monster_entity.pos.y+y<10 && monster_entity.pos.y+y>-1):
			monster_map_layer.erase_cell(monster_entity.pos)
			monster_entity.pos.x +=x
			monster_entity.pos.y +=y
			monster_map_layer.set_cell(monster_entity.pos, 0, Vector2i(0, 0))
	else: move_monster()
func monster_brain():
	monster_hide()
	
func monster_hide():
	if (monster_entity.pos.x - player_entity.pos.x >=-1 && monster_entity.pos.x - player_entity.pos.x <=1 && monster_entity.pos.y - player_entity.pos.y >=-1 && monster_entity.pos.y - player_entity.pos.y <=1):
		monster_map_layer.show()
	else: monster_map_layer.hide()
func monster_chase():
	if (monster_entity.pos.x - player_entity.pos.x >=-1 && monster_entity.pos.x - player_entity.pos.x <=1 && monster_entity.pos.y - player_entity.pos.y >=-1 && monster_entity.pos.y - player_entity.pos.y <=1):
		player_entity.pos
