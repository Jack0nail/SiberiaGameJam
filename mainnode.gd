extends Node

@onready var terrain_map_layer: TileMapLayer = $TerrainMap
@onready var object_map_layer: TileMapLayer = $ObjectMap
@onready var fart_map_layer: TileMapLayer = $FartMap
@onready var player_map_layer: TileMapLayer = $PlayerMap
@onready var monster_map_layer: TileMapLayer = $monsterMap

var player_entity 
var monster_entity
var ochered_xod
var players
var player
var turn_order
var turn_index: int
var round: int
var js_path = "res://player_monster.json"

func _ready() -> void:
	
	for y in 10:
		for x in 10:
			terrain_map_layer.set_cell(Vector2i(x, y), 0, Vector2i(randi() % 18, 0))
	var file = FileAccess.open(js_path, FileAccess.READ)
	var js_string = file.get_as_text()
	var data = JSON.parse_string(js_string)
	var turn = data["turn"]
	turn_order = turn["order"]
	turn_index = turn["currentIndex"]
	round = turn["round"]
	players = data["players"]
	monster_entity = Entity.new(Vector2i(randi()%8+1,randi()%8+1),4)
	monster_map_layer.set_cell(monster_entity.pos, 0, Vector2i(0, 0))
	player_map_layer.set_cell(Vector2i(players["P1"]["pos"]["x"],players["P1"]["pos"]["y"]), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(0,0)),0)
	player_map_layer.set_cell(Vector2i(players["P2"]["pos"]["x"],players["P2"]["pos"]["y"]), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(0,9)),1)
	player_map_layer.set_cell(Vector2i(players["P3"]["pos"]["x"],players["P3"]["pos"]["y"]), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(9,0)),2)
	player_map_layer.set_cell(Vector2i(players["P4"]["pos"]["x"],players["P4"]["pos"]["y"]), 1, Vector2i(0, 0))
	player_entity = Entity.new(player_map_layer.get_cell_atlas_coords(Vector2i(9,9)),3)
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
		pass#$BoxContainer.show()

	var numran = randi()%10 
	match numran:
		0:
			$BoxContainer/Control3/head.set("text","Ивент 1:")
			$BoxContainer/Control3/bodyText.set("text","Вам на пути попался бродячий торговец. Он заявляет что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый \"эликсир\", дающий \"прозрение\". Он назвал его \"Кубок огня\", а на этикетке нарисовано 3 острых перца. Примите его предложение?")
			$BoxContainer/Control2/Button.set("text","\"Да, почему нет?\"")
			$BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим")
			
		1:
			$BoxContainer/Control3/head.set("text","Ивент 2:")
			$BoxContainer/Control3/bodyText.set("text","По мере вашего продвижения у вас на пути оказывается завал. Обходить его придётся долго, проходить через него выйдет проблематично.")
			$BoxContainer/Control2/Button.set("text","О как")
			$BoxContainer/Control2/Button2.hide()
			$BoxContainer/Control2/Button2.set("text"," ")
		2:
			$BoxContainer/Control3/head.set("text","Ивент 3:")
			$BoxContainer/Control3/bodyText.set("text","Вам встретился старик в чёрной робе, стоящий на мосту. Мост расположен над пропастью, именуемой \"Ущелье Вечной Опасности\", если верить табличке рядом с ней. Туман скрывает дно, не позволяя понять насколько глубокое это ущелье. \"Вщяк щуда идущий, отвещь на вопрощ и можещь идти. Ответищь неправильно - умрёщь. Какова скорощть лащточки бещ груза?\"")
			$BoxContainer/Control2/Button.set("text","Щто?")
			$BoxContainer/Control2/Button2.set("text","0.050283 маха")
		3:
			$BoxContainer/Control3/head.set("text","Ивент 4:")
			$BoxContainer/Control3/bodyText.set("text","Вы нашли поляну полную сочных, ярких и красочных ягод. Вы решили сорвать немного себе в запас. Быть может и варенье сварите.")
			$BoxContainer/Control2/Button.set("text","О как")
			$BoxContainer/Control2/Button2.hide()
			$BoxContainer/Control2/Button2.set("text"," ")
		4:
			$BoxContainer/Control3/head.set("text","test 4")
			$BoxContainer/Control3/bodyText.set("text","У вас на пути попался бродячий торговец. Он заявляет что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый эликсир, дающий прозрение. Он назвал его Кубок огня, а на этикетке нарисовано 3 острых перца, сложенные в букву Щ. Примите его предложение?")
			$BoxContainer/Control2/Button.set("text","\"Да, почему нет?\" (На 2-3 хода получаешь возможность видеть дальше на 1 клетку, но другие игроки тут же узнают о твоём местоположении) \"Этот напиток разливается по вашему телу, согревая его своей остротой. Ваши рецепторы тут же взорвались, лицо покрылось испаринами а тело, словно ракета, подлетело в небо, открывая вам виды вокруг. По приземлении, торговца вы уже не обнаружили, но вы уверены, что вы не остались незамеченными.\"")
			$BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим.\" (ничего не меняется) \"Вы пошли своим путём дальше, оставляя торговца позади")
		5:
			$BoxContainer/Control3/head.set("text","test 5")
			$BoxContainer/Control3/bodyText.set("text","У вас на пути попался бродячий торговец. Он заявляет что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый эликсир, дающий прозрение. Он назвал его Кубок огня, а на этикетке нарисовано 3 острых перца, сложенные в букву Щ. Примите его предложение?")
			$BoxContainer/Control2/Button.set("text","\"Да, почему нет?\" (На 2-3 хода получаешь возможность видеть дальше на 1 клетку, но другие игроки тут же узнают о твоём местоположении) \"Этот напиток разливается по вашему телу, согревая его своей остротой. Ваши рецепторы тут же взорвались, лицо покрылось испаринами а тело, словно ракета, подлетело в небо, открывая вам виды вокруг. По приземлении, торговца вы уже не обнаружили, но вы уверены, что вы не остались незамеченными.\"")
			$BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим.\" (ничего не меняется) \"Вы пошли своим путём дальше, оставляя торговца позади")
		6:
			$BoxContainer/Control3/head.set("text","test 6")
			$BoxContainer/Control3/bodyText.set("text","У вас на пути попался бродячий торговец. Он заявляет что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый эликсир, дающий прозрение. Он назвал его Кубок огня, а на этикетке нарисовано 3 острых перца, сложенные в букву Щ. Примите его предложение?")
			$BoxContainer/Control2/Button.set("text","\"Да, почему нет?\" (На 2-3 хода получаешь возможность видеть дальше на 1 клетку, но другие игроки тут же узнают о твоём местоположении) \"Этот напиток разливается по вашему телу, согревая его своей остротой. Ваши рецепторы тут же взорвались, лицо покрылось испаринами а тело, словно ракета, подлетело в небо, открывая вам виды вокруг. По приземлении, торговца вы уже не обнаружили, но вы уверены, что вы не остались незамеченными.\"")
			$BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим.\" (ничего не меняется) \"Вы пошли своим путём дальше, оставляя торговца позади")
		7:
			$BoxContainer/Control3/head.set("text","test 7")
			$BoxContainer/Control3/bodyText.set("text","У вас на пути попался бродячий торговец. Он заявляет что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый эликсир, дающий прозрение. Он назвал его Кубок огня, а на этикетке нарисовано 3 острых перца, сложенные в букву Щ. Примите его предложение?")
			$BoxContainer/Control2/Button.set("text","\"Да, почему нет?\" (На 2-3 хода получаешь возможность видеть дальше на 1 клетку, но другие игроки тут же узнают о твоём местоположении) \"Этот напиток разливается по вашему телу, согревая его своей остротой. Ваши рецепторы тут же взорвались, лицо покрылось испаринами а тело, словно ракета, подлетело в небо, открывая вам виды вокруг. По приземлении, торговца вы уже не обнаружили, но вы уверены, что вы не остались незамеченными.\"")
			$BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим.\" (ничего не меняется) \"Вы пошли своим путём дальше, оставляя торговца позади")
		8:
			$BoxContainer/Control3/head.set("text","test 8")
			$BoxContainer/Control3/bodyText.set("text","У вас на пути попался бродячий торговец. Он заявляет что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый эликсир, дающий прозрение. Он назвал его Кубок огня, а на этикетке нарисовано 3 острых перца, сложенные в букву Щ. Примите его предложение?")
			$BoxContainer/Control2/Button.set("text","\"Да, почему нет?\" (На 2-3 хода получаешь возможность видеть дальше на 1 клетку, но другие игроки тут же узнают о твоём местоположении) \"Этот напиток разливается по вашему телу, согревая его своей остротой. Ваши рецепторы тут же взорвались, лицо покрылось испаринами а тело, словно ракета, подлетело в небо, открывая вам виды вокруг. По приземлении, торговца вы уже не обнаружили, но вы уверены, что вы не остались незамеченными.\"")
			$BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим.\" (ничего не меняется) \"Вы пошли своим путём дальше, оставляя торговца позади")
		9:
			$BoxContainer/Control3/head.set("text","test 9")
			$BoxContainer/Control3/bodyText.set("text","У вас на пути попался бродячий торговец. Он заявляет что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый эликсир, дающий прозрение. Он назвал его Кубок огня, а на этикетке нарисовано 3 острых перца, сложенные в букву Щ. Примите его предложение?")
			$BoxContainer/Control2/Button.set("text","\"Да, почему нет?\" (На 2-3 хода получаешь возможность видеть дальше на 1 клетку, но другие игроки тут же узнают о твоём местоположении) \"Этот напиток разливается по вашему телу, согревая его своей остротой. Ваши рецепторы тут же взорвались, лицо покрылось испаринами а тело, словно ракета, подлетело в небо, открывая вам виды вокруг. По приземлении, торговца вы уже не обнаружили, но вы уверены, что вы не остались незамеченными.\"")
			$BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим.\" (ничего не меняется) \"Вы пошли своим путём дальше, оставляя торговца позади")

func move_player(x:int, y:int) -> void:
	if turn_index <= 3:
		match turn_index:
			0:
				if (int(players["P1"]["pos"]["x"])+x<10 && int(players["P1"]["pos"]["x"])+x>-1 && int(players["P1"]["pos"]["y"])+y<10 && int(players["P1"]["pos"]["y"])+y>-1):
					player_map_layer.erase_cell(Vector2i(players["P1"]["pos"]["x"],players["P1"]["pos"]["y"]))
					players["P1"]["pos"]["x"] += x
					players["P1"]["pos"]["y"] += y
					player_map_layer.set_cell(Vector2i(players["P1"]["pos"]["x"],players["P1"]["pos"]["y"]), 1, Vector2i(0, 0))
					fart_map_layer.erase_cell(Vector2i(players["P1"]["pos"]["x"],players["P1"]["pos"]["y"]))
					_rannum()
					turn_index += 1
			1:
				if (int(players["P2"]["pos"]["x"])+x<10 && int(players["P2"]["pos"]["x"])+x>-1 && int(players["P2"]["pos"]["y"])+y<10 && int(players["P2"]["pos"]["y"])+y>-1):
					player_map_layer.erase_cell(Vector2i(players["P2"]["pos"]["x"],players["P2"]["pos"]["y"]))
					players["P2"]["pos"]["x"] += x
					players["P2"]["pos"]["y"] += y
					player_map_layer.set_cell(Vector2i(players["P2"]["pos"]["x"],players["P2"]["pos"]["y"]), 1, Vector2i(0, 0))
					fart_map_layer.erase_cell(Vector2i(players["P2"]["pos"]["x"],players["P2"]["pos"]["y"]))
					_rannum()
					turn_index += 1
			2:
				if (int(players["P3"]["pos"]["x"])+x<10 && int(players["P3"]["pos"]["x"])+x>-1 && int(players["P3"]["pos"]["y"])+y<10 && int(players["P3"]["pos"]["y"])+y>-1):
					player_map_layer.erase_cell(Vector2i(players["P3"]["pos"]["x"],players["P3"]["pos"]["y"]))
					players["P3"]["pos"]["x"] += x
					players["P3"]["pos"]["y"] += y
					player_map_layer.set_cell(Vector2i(players["P3"]["pos"]["x"],players["P3"]["pos"]["y"]), 1, Vector2i(0, 0))
					fart_map_layer.erase_cell(Vector2i(players["P3"]["pos"]["x"],players["P3"]["pos"]["y"]))
					_rannum()
					turn_index += 1
			3:
				if (int(players["P4"]["pos"]["x"])+x<10 && int(players["P4"]["pos"]["x"])+x>-1 && int(players["P4"]["pos"]["y"])+y<10 && int(players["P4"]["pos"]["y"])+y>-1):
					player_map_layer.erase_cell(Vector2i(players["P4"]["pos"]["x"],players["P4"]["pos"]["y"]))
					players["P4"]["pos"]["x"] += x
					players["P4"]["pos"]["y"] += y
					player_map_layer.set_cell(Vector2i(players["P4"]["pos"]["x"],players["P4"]["pos"]["y"]), 1, Vector2i(0, 0))
					fart_map_layer.erase_cell(Vector2i(players["P4"]["pos"]["x"],players["P4"]["pos"]["y"]))
					_rannum()
					turn_index += 1
	else: 
		turn_index = 0
		round +=1
		
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
	
