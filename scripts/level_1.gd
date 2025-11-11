extends Node2D


var tile_size = 70  # Размер клетки
var grid_size = Vector2(10, 10)  # Размер сетки
var player_pos = Vector2(0, 0)  # Позиция игрока в клетках
   

func grid_to_world(grid_pos):
	return grid_pos * tile_size + Vector2(tile_size/2, tile_size/2)

func world_to_grid(world_pos):
	return Vector2(
		floor(world_pos.x / tile_size),
		floor(world_pos.y / tile_size)
	)
	
func _on_button_10_pressed() -> void: 
	
	if (randi()%100+1) <= 20:
		
		$BoxContainer.show()
		
		var numran = randi()%10 
		
		if  numran == 0:
			$BoxContainer/head.set("text","test 0")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 1:
			$BoxContainer/head.set("text","test 1")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 2:
			$BoxContainer/head.set("text","test 2")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 3:
			$BoxContainer/head.set("text","test 3")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 4:
			$BoxContainer/head.set("text","test 4")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 5:
			$BoxContainer/head.set("text","test 5")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 6:
			$BoxContainer/head.set("text","test 6")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 7:
			$BoxContainer/head.set("text","test 7")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 8:
			$BoxContainer/head.set("text","test 8")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			return
		elif numran == 9:
			$BoxContainer/head.set("text","test 9")
			$BoxContainer/bodytext.set("text","ya yebal no ya smog")
			$BoxContainer/Control2/Button.set("text","sosal")
			$BoxContainer/Control2/Button2.set("text","ebali")
			return
	else: return	



func _on_button_pressed() -> void:
	$BoxContainer.hide()



func _on_button_2_pressed() -> void:
	$BoxContainer.hide()
