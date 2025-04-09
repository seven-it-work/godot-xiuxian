extends VBoxContainer

@export var people:People

func _process(delta: float) -> void:
	if is_instance_valid(people):
		$人物等级.text = "等级：" + str(people.lv.current)
		$年龄.text = "年龄：%s岁" % str(people.get_age("year"))
		$寿命.propertie.current=people.get_age()
	pass

func init(people:People):
	self.people=people
	$人物名称.text = people.name_str
	if people.is_man: 
		$"性别".text="性别：男" 
	else: 
		$"性别".text="性别：女" 
	$寿命.propertie=people.max_life
	$灵气值.propertie=people.lingqi
	$吸收灵气量.propertie=people.lingqi_absorb
	$吸收灵气冷却.propertie=people.lingqi_absorb_cool_time
	$生命值.propertie=people.hp
	$攻击力.propertie=people.atk
	$防御力.propertie=people.def
	$集气速度.propertie=people.attack_speed
	$逃跑概率.propertie=people.fight_escape_probability
	$怀孕周期.propertie=people.pregnancy
	$"动作速度".propertie=people.action_cool_time
	pass
