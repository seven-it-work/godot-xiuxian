class_name Relation extends Node2D

## 唯一id
var id:String=""
@export var name_str:String=""
@export var relation_value:int=0;
@export var source_people_id:String=""
@export var target_people_id:String=""

static func create_relation(sourePeopleId:String,targetPeopleId:String)->Relation:
	var re=Relation.new()
	re.name_str="一面之缘"
	re.relation_value=5
	re.source_people_id=sourePeopleId;
	re.target_people_id=targetPeopleId
	return re;

func save_json():
	var re:Dictionary={}
	re.merge({
		"filename" : get_script().resource_path,
		"name_str":self.name_str,
		"relation_value":self.relation_value,
		"source_people_id":self.source_people_id,
		"target_people_id":self.target_people_id,
	},true)
	return re
	
func load_json(json:Dictionary):
	name_str=json["name_str"]
	relation_value=json["relation_value"]
	source_people_id=json["source_people_id"]
	target_people_id=json["target_people_id"]


## 增加关系
func add_relation(n:int):
	relation_value+=n;

func _init() -> void:
	id=uuid.v4()
	pass
