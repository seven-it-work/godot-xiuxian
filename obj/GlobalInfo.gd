@tool
extends Node
static var is_pause:bool=true
static var place_map:Dictionary={}
# 这是放在所有人一样对象
static var people_map:Dictionary={}
static var is_debugger:bool=false
static var player:People
# 游戏开始时间 每+1标识一天 基础单位天
static var game_time:int=10000
# 一个字典存放一些统计数据
static var statistics_map:Dictionary={}
# 一些游戏设置信息
static var game_setting:Dictionary={}

## 通过人员id获取人员
static func get_people_by_id(id:String)->People:
	if people_map.has(id):
		return people_map[id]
	# 已经被移除了
	return null

## 死亡，移除人
static func remove_people(target:People):
	if GlobalInfo.place_map.has(target.place_id):
		GlobalInfo.place_map.get(target.place_id).outgoing(target)
	GlobalInfo.people_map.erase(target.id)
	# 在statistics_map中key为死亡人数+1
	statistics_map["死亡人数"]+=1

## 初始化统计信息里的一些数据
static func init_statistics_map():
	statistics_map["年初人口数"]=people_map.values().size()
	statistics_map["出生人数"]=0
	statistics_map["死亡人数"]=0


static func init_game_setting():
	# 最大人口数为100
	game_setting["最大人口数"]=100


static func start_new():
	init_game_setting()
	# 随机生成地点、人员、玩家信息
	for i in 10:
		var place=Place.new()
		place.name_str="地点%s"%i
		place_map[place.id]=place;
	for i in game_setting["最大人口数"]:
		var people:People=preload("res://obj/people/People.tscn").instantiate()
		people.name_str="ai%s"%i
		people.is_man=randi_range(0,1)==0
		people_map[people.id]=people;
		var p:Place= place_map.values().pick_random()
		p.enter(people)
	var people=preload("res://obj/people/People.tscn").instantiate()
	#people.is_player=true
	people.name_str="玩家"
	people_map[people.id]=people;
	var p:Place= place_map.values().pick_random()
	p.enter(people)
	
	player=people

	init_statistics_map()
	pass

static func has_save_file()->bool:
	return FileAccess.file_exists("user://savegame.save")

static func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify({
		"place_map":ObjectUtils.obj_2_json(place_map),
		"people_map":ObjectUtils.obj_2_json(people_map),
	})
	save_file.store_line(json_string)


static func load_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_str=save_file.get_as_text()
	var json=JSON.parse_string(json_str)
	place_map=ObjectUtils.json_2_obj(json["place_map"])
	people_map=ObjectUtils.json_2_obj(json["people_map"])
