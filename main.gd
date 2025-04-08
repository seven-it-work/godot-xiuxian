class_name Main
extends Node2D

func _init() -> void:
	GlobalInfo.main_node=self
	pass

func _ready() -> void:
	Log.info("开始")
	_on_start_game_pressed()
	pass

func _process(delta: float) -> void:
	if GlobalInfo.is_pause:
		$"HBoxContainer/玩家信息/VBoxContainer/相关按钮/暂停".text="继续"
	else:
		$"HBoxContainer/玩家信息/VBoxContainer/相关按钮/暂停".text="暂停"
	pass

# 切换tips
func change_tips(tipsTscnName:String,data):
	var tips=$HBoxContainer/tips.find_child(tipsTscnName)
	if tips:
		# 隐藏其它的节点
		for i in $HBoxContainer/tips.get_children():
			i.hide()
		if tips.has_method("init"):
			tips.init(data)
		tips.show()
		pass
	else:
		Log.error("不存在场景",tipsTscnName)
	pass

func _on_start_game_pressed() -> void:
#	新游戏
	GlobalInfo.start_new()
	_start_game()
	$"HBoxContainer/玩家信息/VBoxContainer/VBoxContainer/人物详情".init(GlobalInfo.player)
	$"HBoxContainer/core/地图".init()
	$"HBoxContainer/core/地图内容".init(GlobalInfo.place_map[GlobalInfo.player.place_id])
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
			var birth_rate=GlobalInfo.statistics_map["生产孩子"]/avg_people_size
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
#		#这里要打乱人员顺序
		for data:People in GlobalInfo.people_map.values():
			if data.is_player:
				data.hp.add_current(100)
			data.do_action()
		for data:Place in GlobalInfo.place_map.values():
			data.do_action()
		# 执行ai与玩家的交互动作
		#for data:DecisionEntity in GlobalInfo.ai_interaction_queue:
			## todo 如果玩家愿意则执行，否则不执行
			#data.execute({"people":self},true)
		GlobalInfo.ai_interaction_queue.clear()
		pass
	pass # Replace with function body.


func _on_暂停_pressed() -> void:
	GlobalInfo.is_pause=!GlobalInfo.is_pause
	if !GlobalInfo.is_pause:
		$"HBoxContainer/tips/人员点击tips".hide()
	pass # Replace with function body.


func _on_游戏速度_value_changed(value: float) -> void:
	$"时间流逝".wait_time=1/value
	pass # Replace with function body.
