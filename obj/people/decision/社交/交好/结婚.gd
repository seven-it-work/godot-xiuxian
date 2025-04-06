class_name MarriageDecision
extends DecisionEntity
var people:People
var target_people:People

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 18岁以下不能结婚
	if target_people.get_age("year")<18:
		return Result.FAILURE
	# 如果target_people是玩家 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	# 如果target_people是同性 则返回失败
	if target_people.is_man==people.is_man:
		return Result.FAILURE
	return Result.SUCCESS

func _execute()->int:
	# 结婚一个新人，结婚列表中的所有人之前关系-50
	for id in people.wife_list:
		var other:People = GlobalInfo.get_people_by_id(id)
		if other==null:
			# 对方已经死亡了
			continue
		people.add_relation(other, -50)
	people.wife_list.append(target_people.id)
	target_people.wife_list.append(people.id)
	people.add_relation(target_people,randi_range(20,40))
	return Result.SUCCESS

func get_action_key()->String:
	return "结婚"

func _after_execute():
	pass
