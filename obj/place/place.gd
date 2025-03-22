class_name Place extends Action
## 唯一id
var id:String=""
@export var name_str:String=""
## 用于的人员idlist
@export var people_id_list:Array=[]
## 灵气值
@export var current_lin_qi:BarPropertie
## 生产速度
@export var product_speeding:RandomPropertie
@export var product_speeding_times:int=0;
## 生产量 （每生产速度时间生产多少灵气）
@export var product_value:RandomPropertie

func _ready() -> void:
	print(Place.new().save_json())
	pass
	
func do_action():
	if product_speeding_times>0:
		product_speeding_times-=1
		return
	Log.debug("生产灵力")
	product_speeding_times=product_speeding.get_current()
	current_lin_qi.add_current(product_value.get_current())

func save_json():
	var re:Dictionary={}
	re.merge({
		"filename" : get_script().resource_path,
		"id":self.id,
		"name_str":self.name_str,
		"people_id_list":ObjectUtils.obj_2_json(people_id_list),
		"current_lin_qi":ObjectUtils.obj_2_json(current_lin_qi),
		"product_speeding":ObjectUtils.obj_2_json(product_speeding),
		"product_value":ObjectUtils.obj_2_json(product_value),
	},true)
	return re
	
func load_json(json:Dictionary):
	id=json["id"]
	name_str=json["name_str"]
	people_id_list=json["people_id_list"]
	current_lin_qi=ObjectUtils.json_2_obj(json["current_lin_qi"])
	product_speeding=ObjectUtils.json_2_obj(json["product_speeding"])
	product_value=ObjectUtils.json_2_obj(json["product_value"])
	


func _init() -> void:
	self.load_json(JSON.parse_string(FileAccess.open("res://obj/place/place.json",FileAccess.READ).get_as_text()))
	id=uuid.v4()
	pass

## 获得当前所在的所有人员
func get_all_people()->Array:
	var re=[]
	for id in people_id_list:
		re.append(GlobalInfo.people_map[id])
	return re;

## 获取其他人的id
func get_other_people_id_list(people_id:String)->Array:
	return people_id_list.filter(func(id): return id!=people_id)

## 是否存在其他人
func has_other_people(people_id:String)->bool:
	for i in people_id_list:
		if i!=people_id:
			return true;
	return false;

## 是否存在此人员
func has_people(people_id:String)->bool:
	return people_id_list.has(people_id)

## 查询人员
func find_people(people_id:String)->People:
	if has_people(people_id):
		return GlobalInfo.people_map[people_id]
	return null

## 进入当前地点
func enter(people:People):
	people_id_list.append(people.id)
	people.place_id=self.id

## 走出当前地点
func outgoing(people:People):
	people_id_list=get_other_people_id_list(people.id)
	people.place_id=""
