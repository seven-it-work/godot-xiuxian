class_name SocialDecision
extends DecisionEntity

@onready var people:People
var target_people:People

func _init(people:People):
	self.people=people

func get_action_key()->String:
	return "社交"

func _before_execute()->int:
	if GlobalInfo.place_map.is_empty():
		return Result.FAILURE
	var place:Place=GlobalInfo.place_map[people.place_id]
	# 随机选择一个人
	var target_people_list=place.get_other_people_id_list(people.id)
	if target_people_list.is_empty():
		return Result.FAILURE
	var target_id=target_people_list.pick_random()
	target_people=GlobalInfo.get_people_by_id(target_id)
	if target_people==null:
		# 表示这个人死亡了不进行操作了
		return Result.FAILURE
	return Result.SUCCESS

func _execute()->int:
	var weight_1={
		"交好":GlobalInfo.game_setting["最大人口数"],
		"交恶":GlobalInfo.people_map.values().size(),
	}
	if people.relation.has(target_people.id):
		var re=people.relation.get(target_people.id)
		if re.relation_value>0:
			weight_1["交好"]+=re.relation_value
		else:
			weight_1["交恶"]-=re.relation_value
	var temp=ObjectUtils.weight_selector({
		SocialGoodDecision.new(people,target_people):weight_1["交好"],
		SocialBadDecision.new(people,target_people):weight_1["交恶"],
	})
	return temp[0].execute()

func _after_execute():
	return Result.SUCCESS
