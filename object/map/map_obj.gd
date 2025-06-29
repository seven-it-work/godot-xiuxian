extends DoAction
class_name MapObj
var uid:String=""
## 名称
@export var name_str=""
## 怪物列表
@onready var master_list=$Properties/master_list

## 当前人员合集
var people_dic:Dictionary={}

func people_enter(p:PeopleObj):
	p.current_place_id=uid
	people_dic[p.uid]=p;

func people_leave(p:PeopleObj):
	p.current_place_id=""
	people_dic.erase(p.uid)


func _ready() -> void:
	var t=load("res://object/people/Monster.tscn").instantiate()
	t.name_str="怪物1"
	master_list.add_child(t)
	self.uid=uuid.v4()
	init()
	pass

func do_action():
	pass

func init():
	$ui/MapTipsButton.text=name_str
	pass

func get_ui(key:String):
	var result=$ui.find_child(key).duplicate()
	return result

func _on_map_tips_button_pressed() -> void:
	var main_node=get_node("/root/Main")
	main_node.change_tips("MapTips",self);
	pass # Replace with function body.
