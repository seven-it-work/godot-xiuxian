extends PanelContainer

func init():
	var player:PeopleObj=get_node("/root/Main/AllData/PlayerList/Player")
	find_child("人物名称").text = player.name_str
	if player.is_man: 
		find_child("性别").text="性别：男" 
	else: 
		find_child("性别").text="性别：女"
	$"VBoxContainer/基础信息/简单信息/人物名称".text="名称：%s"%player.name_str
	$"VBoxContainer/基础信息/简单信息/人物等级".text="等级：%d"%player.lv.get_current()
	$"VBoxContainer/基础信息/简单信息/年龄".text="年龄：%d"%DateUtils.convert_days(player.age.get_current())
	var property_list=[
		# "lingqi",
		"hp",
		# "lingqi_absorb",
		"atk",
		# "lingqi_absorb_cool_time",
		"def",
		# "attack_speed",
		# "max_life",
		# "action_cool_time",
		# "pregnancy",
		# "fight_escape_probability"
	]
	for property in property_list:
		var property_ui=preload("res://ui/ui组件/属性组件.tscn").instantiate()
		$"VBoxContainer/属性信息".add_child(property_ui)
		property_ui.init(player.get_attribute_data(property))
	pass

	
func _process(delta: float) -> void:
	pass
	
