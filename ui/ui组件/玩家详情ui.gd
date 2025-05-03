extends PanelContainer
@export var people:PeopleObj

func _update(people:PeopleObj):
	self.people=people
	find_child("人物名称").text = people.name_str
	if people.is_man: 
		find_child("性别").text="性别：男" 
	else: 
		find_child("性别").text="性别：女"
	$"VBoxContainer/基础信息/简单信息/人物名称".text="名称：%s"%people.name_str
	$"VBoxContainer/基础信息/简单信息/人物等级".text="等级：%d"%people.lv.get_current()
	$"VBoxContainer/基础信息/简单信息/年龄".text="年龄：%d"%people.get_age("year")
	var property_list=[
		"lingqi",
		"hp",
		"lingqi_absorb",
		"atk",
		"lingqi_absorb_cool_time",
		"def",
		"attack_speed",
		"max_life",
		"action_cool_time",
		"pregnancy",
		"fight_escape_probability"
	]
	for property in property_list:
		var property_ui=preload("res://ui/ui组件/属性组件.tscn").instantiate()
		$"VBoxContainer/属性信息".add_child(property_ui)
		property_ui._update(people.get_attribute_data(property))
	pass

	
func _process(delta: float) -> void:
	pass
	
