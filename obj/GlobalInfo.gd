@tool
extends Node
static var is_pause:bool=true
static var place_map:Dictionary={}
static var people_map:Dictionary={}
static var is_debugger:bool=false
static var player:People
# +1表示+1秒
static var game_time:float=Time.get_unix_time_from_system()

static func remove_people(target:People):
	GlobalInfo.place_map[target.place_id].outgoing(target)
	GlobalInfo.people_map.erase(target.id)

static func start_new():
	# 随机生成地点、人员、玩家信息
	for i in 10:
		var place=Place.new()
		place.name_str="地点%s"%i
		place_map[place.id]=place;
	for i in 10:
		var people:People=preload("res://obj/people/People.tscn").instantiate()
		people.name_str="ai%s"%i
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
