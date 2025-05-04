class_name PeopleObj
extends DoAction

var uid:String=""
var current_place_id:String=""
@export var name_str:String=""
@export var is_man:bool=true

@onready var hp: Property = $Properties/hp
@onready var atk: Property = $Properties/atk
@onready var def: Property = $Properties/def
@onready var lv:Property=$Properties/lv
@onready var age:Property=$Properties/age


func get_age():
	pass

func do_action():
	print("执行了")
	pass

###### Equipment

func enter_map(m:MapObj):
	var currentMapObj=get_current_mapObj()
	if currentMapObj:
		currentMapObj.people_leave(self)
	m.people_enter(self)

func get_current_mapObj()->MapObj:
	if StrUtils.is_blank(self.current_place_id):
		return null
	var mapList=get_node("/root/Main/AllData/MapList").get_children()
	var filterData=mapList.filter(func(data): return data.uid==self.current_place_id)
	if filterData.size()==1:
		return filterData.get(0)
	Log.err("错误地图信息:"+self.current_place_id,filterData)
	return null
	
func _ready() -> void:
	self.uid=uuid.v4()
	pass


#### 工具方法放这里

# get_attribute_data 通过属性名称获取属性数据
func get_attribute_data(propertyKey:String)->Property:
	var node=find_child(propertyKey)
	if node==null:
		Log.err("属性不存在:"+propertyKey)
		return null
	return node as Property

##################
