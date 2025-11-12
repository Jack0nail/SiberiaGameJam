extends Node

@export var player: PackedScene
@export var enemy: PackedScene

@onready var terrain_map_layer: TileMapLayer = $MapNode/TerrainMap
@onready var object_map_layer: TileMapLayer = $MapNode/ObjectMap
@onready var border_map_layer: TileMapLayer = $MapNode/BorderMap
@onready var player_on_map = $MapNode/Playerr
@onready var bot_list: Array[Node] = [$MapNode/Playerr2, $MapNode/Playerr3, $MapNode/Playerr4, $MapNode/Enemy]
@onready var unit_list: Array[Node]
@onready var hp = $MapNode/HP

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
	$HTTPRequest.request_completed.connect(_on_gen_map_completed)
	$HTTPRequest2.request_completed.connect(_on_get_map_completed)
	
	## generate new map
	#gen_map()
	
	## get map by num
	get_map()
	
	$obuch.show()
	$obuch/BoxContainer/Control3/bodyText.set("text", "	Привет! Я - Жорик, твой гид. Игра развивается, и ты сейчас находишься в стартовом билде. Каждый раз, как ты оказываешься в этих землях, ландшафт уникальный! Мы используем процедурную генерацию и систему событий, чтобы разнообразить твой опыт. Изначально идея задумывалась как мультиплеерная игра, в которой враги - другие игроки с той же целью, что и ты. Но за уложенные для геймджема сроки мы решили сделать синглплеерный билд. Если есть советы или предложения, комментарии на itch.io к твоему распоряжению.")
	$obuch/BoxContainer/Control3/head2.set("text","Как играть?")
				
func _on_gen_map_completed(result, response_code, headers, body):
	json = JSON.parse_string(body.get_string_from_utf8())
	json = json["map"]
	reset_game()
	
func _on_get_map_completed(result, response_code, headers, body):
	json = JSON.parse_string(body.get_string_from_utf8())
	reset_game()
	
func gen_map() -> void:
	$HTTPRequest.request("https://peak.e-dt.ru/maps/gen_map")
	
func get_map(id: int = 2) -> void:
	$HTTPRequest2.request("https://peak.e-dt.ru/maps/get_map/" + str(id))
	
	
func reset_game() -> void:
	## global size map
	map_size.x = json["size"]["width"]
	map_size.y = json["size"]["height"]
	
	## clear all map layer
	terrain_map_layer.clear()
	object_map_layer.clear()
	border_map_layer.clear()
	
	var pos_list: Array[Vector2i] = [Vector2i(0,0), Vector2i(0, map_size.y-1), Vector2i(map_size.x-1, 0), Vector2i(map_size.x-1, map_size.y-1)]
	
	## gen player
	for i in 4:
		var p = player.instantiate()
		p.pos = pos_list[i]
		var global_pos = terrain_map_layer.to_global(terrain_map_layer.map_to_local(p.pos))
		global_pos.y -= 15
		p.global_position = global_pos
		unit_list.append(p)
		$MapNode.add_child(p)
	
	
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
			terrain_map_layer.set_cell(Vector2i(i["x"], i["y"]), 0, Vector2i(3, 9))
			
				
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
							$obuch.show()
							$obuch/BoxContainer/Control3/bodyText.set("text","Хей, я смотрю ты сделал это! Так вот как выглядит этот.. ну.. как его.. икосэдр. Теперь нам нужно вернуться домой и рассказать всем о нашем приключении! Мы - герои спасшие.. священный камень!")
							$obuch/BoxContainer/Control3/head2.set("text","ПОЗДРАВЛЯЮ")
							$obuch/BoxContainer/Control2/Button_obuch.set("text","В смысле \"мы\"?")
							$obuch/BoxContainer/Control2/ChevronBigLeftWhite.hide()
							#$Button2.show()
							
						await get_tree().create_timer(1.0).timeout
						
						## move all bot
						move_bots()
				else:
					set_is_move(false)
					bot_attack(get_attack_bot_index(cell_cord), -1)
					await get_tree().create_timer(1.0).timeout
					reset_border()
					move_bots()

func _on_button_pressed() -> void:
	$PanelContainer.hide()
	match $PanelContainer/BoxContainer/Control3/head.get("text"):
		"Ивент 1:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Этот напиток разливается по вашему телу, согревая его своей остротой. Ваши рецепторы тут же взорвались, лицо покрылось испаринами, а тело, словно ракета, подлетело в небо, открывая вам виды вокруг. По приземлении, торговца вы уже не обнаружили.")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Ну и пойло")
			$rezult.show()
		"Ивент 2:":
			pass
		"Ивент 3:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Старик усмехается вашей глупости и произносит заклинание, отправляющее вас в полёт на дно пропасти. Полёт оказался, не такой долгий. Пропасть была 5 метров в высоту. Приземление было болезненное, а вылезти из этой дыры у вас займёт определенное время.")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Старый хрыч! И как выбираться?")
			$rezult.show()
		"Ивент 4:":
			pass
		"Ивент 5:":
			pass
		"Ивент 6:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Вы провели отлично время в компании забавных человечков. Один даже пригласил вас в будущем на свадьбу своей внучки!")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Какие приятные дедки. Так когда там свадьба?")
			$rezult.show()
		"Ивент 7:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Когда вы помогли перенести бревно, желтый и коричневый бобры пришли к вам из общей массы, встали как люди и протянули лапу. \"Спасиб, мужик. Помог. Держи краба\". Пожав им лапу и уйдя дальше, вы чувствуете, как ваше тело окрепло.")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Где-то я этих бобров видел.. они крутые.")
			$rezult.show()
		"Ивент 8:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Менестрель воодушевился вашими историями и написал песню о вас, ваших приключениях и о том, какой вы смелый и могучий воин!")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Может забрать его на обратном пути?")
			$rezult.show()
		"Ивент 9:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Вы почесали собаку и оба остались довольны. :)")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Хороший мальчик!")
			$rezult.show()
		"Ивент 10:":
			pass
			
func _on_button_2_pressed() -> void:
	$PanelContainer.hide()
	match $PanelContainer/BoxContainer/Control3/head.get("text"):
		"Ивент 1:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Оставив позади этого безумца, вы направились дальше к своей цели.")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Не дай бог отравлюсь!")
			$rezult.show()
		"Ивент 2:":
			pass
		"Ивент 3:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Старик вопросительно смотрит на вас. \"Я не щнаю?\" После чего его какой-то силой выталкивает с моста вниз, в пропасть. Туман рассеивается, и вы видите, что пропасть оказалась не более чем ямой, на дне которой лежит старик. \"Ладно, твоя вщяла. Мощещь идти.\"")
			$rezult/BoxContainer/Control2/Button_rez.set("text","О как. Так какой ласточки?")
			$rezult.show()
		"Ивент 4:":
			pass
		"Ивент 5:":
			pass
		"Ивент 6:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Вы решили оставить малышей позади, ведь у вас впереди бравый квест!")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Ну их, впереди меня ждёт приключение!")
			$rezult.show()
		"Ивент 7:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Животные сами разберутся.")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Эти бобры выглядят круто, сами справятся.")
			$rezult.show()
		"Ивент 8:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Вы решили покрасоваться своим могучим телом. Вы увидели как огонь загорается в его глазах, а рука сама расписывает бумагу, повествуя  о невероятности вашей физической формы!")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Мне кажется он странно на меня смотрел.")
			$rezult.show()
		"Ивент 9:":
			$rezult/BoxContainer/Control3/bodyText.set("text","Вы почесали собаку и оба остались довольны. :)")
			$rezult/BoxContainer/Control2/Button_rez.set("text","Хороший мальчик!")
			$rezult.show()
		"Ивент 10:":
			pass

func _rannum():
	if (randi()%100) <= 19:
		$PanelContainer.show()
	var numran = randi()%10 
	match numran:
		0:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 1:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","У вас на пути попался бродячий торговец. Он заявляет, что он успешный зельевар, хоть вы о нем никогда не слышали. Он предлагает опробовать вам свой новый эликсир, дающий прозрение. Он назвал его \"Кубок огня\", а на этикетке нарисовано 3 острых перца. Примите его предложение?")
			$PanelContainer/BoxContainer/Control2/Button.set("text","\"Да, почему нет?\"")
			$PanelContainer/BoxContainer/Control2/Button2.set("text","Нет, лучше не доверять прохожим")
			$PanelContainer/BoxContainer/Control2/Button2.show()
			$PanelContainer/BoxContainer/Control2/Button3.hide()
			
		1:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 2:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","По мере вашего продвижения у вас на пути оказывается завал. Обходить его придётся долго, проходить через него выйдет проблематично.")
			$PanelContainer/BoxContainer/Control2/Button.set("text","И кто в этом виноват?!")
			$PanelContainer/BoxContainer/Control2/Button2.hide()
			$PanelContainer/BoxContainer/Control2/Button2.set("text","")
			$PanelContainer/BoxContainer/Control2/Button3.hide()
		2:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 3:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Вам встретился старик в чёрной робе, стоящий на мосту. Мост расположен над пропастью, именуемой \"Ущелье Вечной Опасности\", если верить табличке рядом с ней. Туман скрывает дно, не позволяя понять, насколько глубокое это ущелье. \"Вщяк щуда идущий, отвещь на вопрощ и можещь идти. Ответищь неправильно - умрёщь. Какова скорощть лащточки бещ груза? \"")
			$PanelContainer/BoxContainer/Control2/Button.set("text","Щто?")
			$PanelContainer/BoxContainer/Control2/Button2.set("text","Европейской или Африканской?")
			$PanelContainer/BoxContainer/Control2/Button2.show()
			$PanelContainer/BoxContainer/Control2/Button3.set("text","0.050283 маха")
			$PanelContainer/BoxContainer/Control2/Button3.show()
		3:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 4:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Вы нашли поляну, полную сочных, ярких и красочных ягод. Вы решили сорвать немного себе в запас. Быть может, и варенье сварите.")
			$PanelContainer/BoxContainer/Control2/Button.set("text","Оп, крыжопник...")
			$PanelContainer/BoxContainer/Control2/Button2.hide()
			$PanelContainer/BoxContainer/Control2/Button2.set("text","")
			$PanelContainer/BoxContainer/Control2/Button3.hide()
		4:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 5:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Вы проходите мимо палатки, из которой доносится металлический звон. Желая узнать, что в ней, вы увидели низкорослого, бородатого и широкого мужчину, сидящего (или стоящего? Тяжело из-за роста сказать наверняка) перед наковальней. Кузнец Георг, как он представился, любезно предложил заточить ваши когти. После его работы они сияют великолепием.")
			$PanelContainer/BoxContainer/Control2/Button.set("text","Спасибо, старый дед!")
			$PanelContainer/BoxContainer/Control2/Button2.hide()
			$PanelContainer/BoxContainer/Control2/Button2.set("text","")
			$PanelContainer/BoxContainer/Control2/Button3.hide()
		5:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 6:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Под своими ногами вы услышали бормотание и звон посуды. Опустив взгляд, вы подмечаете небольшой чайный столик, за которым сидят забавные старички с красными колпаками. Они приглашают вас к себе на чаепитие. Примете приглашение?")
			$PanelContainer/BoxContainer/Control2/Button.set("text","Да!")
			$PanelContainer/BoxContainer/Control2/Button2.set("text","Нет, спасибо.")
			$PanelContainer/BoxContainer/Control2/Button2.show()
			$PanelContainer/BoxContainer/Control2/Button3.hide()
		6:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 7:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Проходя недалеко от водоёма, вы увидели банду бобров. Они имеют трудности с тем, чтобы перенести бревно к водоёму. Вы им поможете?")
			$PanelContainer/BoxContainer/Control2/Button.set("text","Братья наши меньшие нуждаются в помощи!")
			$PanelContainer/BoxContainer/Control2/Button2.set("text","Животные сами разберутся.")
			$PanelContainer/BoxContainer/Control2/Button2.show()
			$PanelContainer/BoxContainer/Control2/Button3.hide()
		7:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 8:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Вам на пути попался бродячий менестрель. У него возникли проблемы с выбором темы для своей новой баллады, и он просит вас о помощи. О чем она будет?")
			$PanelContainer/BoxContainer/Control2/Button.set("text","Геройский эпос! Про мои приключения!")
			$PanelContainer/BoxContainer/Control2/Button2.set("text","Грех не воспеть это тело!")
			$PanelContainer/BoxContainer/Control2/Button2.show()
			$PanelContainer/BoxContainer/Control2/Button3.hide()
		8:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 9:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Вам на встречу выбегает собака. Язык тела собаки выдает её помыслы - она хочет почесушки. Почешите собаку?")
			$PanelContainer/BoxContainer/Control2/Button.set("text","Да.")
			$PanelContainer/BoxContainer/Control2/Button2.set("text","Да!")
			$PanelContainer/BoxContainer/Control2/Button2.show()
			$PanelContainer/BoxContainer/Control2/Button3.hide()
		9:
			$PanelContainer/BoxContainer/Control3/head.set("text","Ивент 10:")
			$PanelContainer/BoxContainer/Control3/bodyText.set("text","Вы находите брошенный лагерь. Вы не знаете, кто или что стало причиной опустошения лагеря, но при осмотре места вы обнаружили карту окружающей местности. Сравнив картинку с окружением вы поняли, что карта нарисована предельно точно.")
			$PanelContainer/BoxContainer/Control2/Button.set("text","А это полезно!")
			$PanelContainer/BoxContainer/Control2/Button2.hide()
			$PanelContainer/BoxContainer/Control2/Button3.hide()

func _on_button_rez_pressed() -> void:
	$rezult.hide()


func _on_button_3_pressed() -> void:
	$PanelContainer.hide()


func _on_button_obuch_pressed() -> void:
	match $obuch/BoxContainer/Control3/bodyText.get("text"):
		"	Привет! Я - Жорик, твой гид. Игра развивается, и ты сейчас находишься в стартовом билде. Каждый раз, как ты оказываешься в этих землях, ландшафт уникальный! Мы используем процедурную генерацию и систему событий, чтобы разнообразить твой опыт. Изначально идея задумывалась как мультиплеерная игра, в которой враги - другие игроки с той же целью, что и ты. Но за уложенные для геймджема сроки мы решили сделать синглплеерный билд. Если есть советы или предложения, комментарии на itch.io к твоему распоряжению.":
			$obuch/BoxContainer/Control3/bodyText.set("text", "Ты - бравый рыцарь королевства Бойкисс. Тебя отправили на поиски священного Икосаэдра. Я тоже не знаю что это, но когда увидишь его - сразу поймёшь. Из этого места тебе просто так не выбраться. Артефакт впускает, но не выпускает. Где-то здесь присутствует портал. Он же твой единственный выход. Но и он не так прост, поверь моей бороде. Он выпустит только того, кто несет при себе священный Икоса.. камень. Но как только найдёшь этот камень, то все жители этого места объявят на тебя охоту. Пока ты странствуешь, ты можешь наткнуться на неожиданные встречи. Путник в беде или препятствие что мешает продвигаться. Но так даже интереснее. Ведь какой геройский поход остается геройским без проблем, которые герой преодолевает, да?")
		"Ты - бравый рыцарь королевства Бойкисс. Тебя отправили на поиски священного Икосаэдра. Я тоже не знаю что это, но когда увидишь его - сразу поймёшь. Из этого места тебе просто так не выбраться. Артефакт впускает, но не выпускает. Где-то здесь присутствует портал. Он же твой единственный выход. Но и он не так прост, поверь моей бороде. Он выпустит только того, кто несет при себе священный Икоса.. камень. Но как только найдёшь этот камень, то все жители этого места объявят на тебя охоту. Пока ты странствуешь, ты можешь наткнуться на неожиданные встречи. Путник в беде или препятствие что мешает продвигаться. Но так даже интереснее. Ведь какой геройский поход остается геройским без проблем, которые герой преодолевает, да?":
			$obuch/BoxContainer/Control3/bodyText.set("text", "Теперь я расскажу, как твой поход будет проходить. Действия в игре проходят пошагово. В свой ход ты можешь перемещаться, нападать и защищаться. У тебя есть здоровье в виде сердечек. Ты будешь его терять в сражениях или на случайных событиях. Восполнять их ты сможешь в ходе других случайных событий. Ещё, если повезёт, ты получишь бонус дополнительными сердечками. Они поверх твоих основных сердец и не смогут восстановиться после утраты. Ну и обзор. Эти земли покрыты туманом, из-за которого ты дальше своего носа мало что увидишь. Есть, конечно, способы увидеть больше, чем ты можешь сейчас, но тебе нужно будет их найти.")
		"Теперь я расскажу, как твой поход будет проходить. Действия в игре проходят пошагово. В свой ход ты можешь перемещаться, нападать и защищаться. У тебя есть здоровье в виде сердечек. Ты будешь его терять в сражениях или на случайных событиях. Восполнять их ты сможешь в ходе других случайных событий. Ещё, если повезёт, ты получишь бонус дополнительными сердечками. Они поверх твоих основных сердец и не смогут восстановиться после утраты. Ну и обзор. Эти земли покрыты туманом, из-за которого ты дальше своего носа мало что увидишь. Есть, конечно, способы увидеть больше, чем ты можешь сейчас, но тебе нужно будет их найти.":
			$obuch/BoxContainer/Control3/bodyText.set("text", "Ну, братишка, я основные моменты тебе обрисовал, дальше ты сам по себе. Ты мне уже как сын. Всё, не надо слёз, дуй за своим сокровищем. Удачи!")
		"Ну, братишка, я основные моменты тебе обрисовал, дальше ты сам по себе. Ты мне уже как сын. Всё, не надо слёз, дуй за своим сокровищем. Удачи!":
			$obuch.hide()
		"Хей, я смотрю ты сделал это! Так вот как выглядит этот.. ну.. как его.. икосэдр. Теперь нам нужно вернуться домой и рассказать всем о нашем приключении! Мы - герои спасшие.. священный камень!":
			get_tree().change_scene_to_file("res://scene/menu.tscn")


func _on_sound_button_pressed() -> void:
	if $AudioStreamPlayer.playing == true:
		$AudioStreamPlayer.playing = false
		$sound_button.set("icon","res://textures/Group 209.png")
	else: 
		$AudioStreamPlayer.playing = true
		$sound_button.set("icon","res://textures/Group 203.png")
