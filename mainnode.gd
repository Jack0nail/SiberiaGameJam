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
	$obuch.show()
	$obuch/BoxContainer/Control3/bodyText.set("text", "	Привет! Я - Жорик, твой гид. Игра развивается, и ты сейчас находишься в стартовом билде. Каждый раз, как ты оказываешься в этих землях, ландшафт уникальный! Мы используем процедурную генерацию и систему событий, чтобы разнообразить твой опыт. Изначально идея задумывалась как мультиплеерная игра, в которой враги - другие игроки с той же целью, что и ты. Но за уложенные для геймджема сроки мы решили сделать синглплеерный билд. Если есть советы или предложения, комментарии на itch.io к твоему распоряжению.")
	$obuch/BoxContainer/Control3/head2.set("text","Как играть?")
	
	
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
	


func _on_button_rez_pressed() -> void:
	$rezult.hide()


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
