extends Node2D


func _ready() -> void:
	Log.info("开始")
	#if GlobalInfo.has_save_file():
		#$game_start/continue_game.show()
	_on_start_game_pressed()
	#$game_core/core.init_data()
	pass

func _process(delta: float) -> void:
	# 将游戏时间GlobalInfo.game_time转换为年月日
	var year=GlobalInfo.game_time/365
	var days=GlobalInfo.game_time%365
	var time_dir=Time.get_date_dict_from_unix_time(days*86400)
	var month=time_dir["month"]
	var day=time_dir["day"]
	# 将时间字符串给到时间str这个Label
	$"时间str".text=str(year)+"年"+str(month)+"月"+str(day)+"日"
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

# 一年计数器
var year_count:int=0

func _on_时间流逝_timeout() -> void:
	if !GlobalInfo.is_pause:
		# 现实1秒钟  游戏1天
		GlobalInfo.game_time+=1
		year_count+=1
		if year_count>=365:
			# 平均人口
			var avg_people_size:float=(GlobalInfo.people_map.values().size()+GlobalInfo.statistics_map["年初人口数"])/2
			# 计算年出生率
			var birth_rate=GlobalInfo.statistics_map["出生人数"]/avg_people_size
			# 计算年死亡率
			var death_rate=GlobalInfo.statistics_map["死亡人数"]/avg_people_size
			# 计算年人口增长率
			var population_growth_rate=birth_rate-death_rate
			# log记录统计信息以及平均人口
			Log.info("统计信息：%s，平均人口：%s，当前人口数：%s"%[GlobalInfo.statistics_map,avg_people_size,GlobalInfo.people_map.values().size()])
			# 使用Log打印出来
			Log.info("年出生率：%s，年死亡率：%s，年人口增长率：%s"%[birth_rate,death_rate,population_growth_rate])
			# 年数据计算清理
			GlobalInfo.init_statistics_map()
			year_count=0
		for data:People in GlobalInfo.people_map.values():
			data.do_action()
		for data:Place in GlobalInfo.place_map.values():
			data.do_action()
		# 人物年龄处理
		# 人物生育处理
		pass
	pass # Replace with function body.
