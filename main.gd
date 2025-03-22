extends Node2D


func _ready() -> void:
	Log.info("开始")
	#if GlobalInfo.has_save_file():
		#$game_start/continue_game.show()
	_on_start_game_pressed()
	#$game_core/core.init_data()
	pass


func _on_start_game_pressed() -> void:
#	新游戏
	GlobalInfo.start_new()
	_start_game()
	pass # Replace with function body.
	
func _start_game():
	var people_list=$people_list
	for i in people_list.get_children():
		i.free();
	var p=GlobalInfo.people_map
	for data:People in GlobalInfo.people_map.values():
		people_list.add_child(data)
	GlobalInfo.is_pause=false
	pass


func _on_时间流逝_timeout() -> void:
	if !GlobalInfo.is_pause:
		# 现实1秒钟  游戏5分钟
		GlobalInfo.game_time+=1*60*5
		for data:People in GlobalInfo.people_map.values():
			data.do_action()
		for data:Place in GlobalInfo.place_map.values():
			data.do_action()
		# 人物年龄处理
		# 人物生育处理
		pass
	pass # Replace with function body.
