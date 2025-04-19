extends PanelContainer

@export var people:People


func init(people:People):
	self.people=people
	find_child("人物名称").text = people.name_str
	if people.is_man: 
		find_child("性别").text="性别：男" 
	else: 
		find_child("性别").text="性别：女"
	$"VBoxContainer/基础信息/简单信息/人物名称".text="名称：%s"%people.name_str
	$"VBoxContainer/基础信息/简单信息/人物等级".text="等级：%d"%people.lv.get_current()
	$"VBoxContainer/基础信息/简单信息/年龄".text="年龄：%d"%people.get_age("year")
	$"VBoxContainer/属性信息/GridContainer/lingqi".init(people.get_attribute_data("lingqi"))
	$"VBoxContainer/属性信息/GridContainer/lingqi_absorb".init(people.get_attribute_data("lingqi_absorb"))
	pass

	
func _process(delta: float) -> void:
	pass
	
