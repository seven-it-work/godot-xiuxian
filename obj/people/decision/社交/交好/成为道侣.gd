class_name BecomeLoverDecision
extends DecisionEntity

var people:People
var target_people:People

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 15岁以下不能成为道侣
	if target_people.get_age("year")<15:
		return Result.FAILURE
	# 如果说target_people是ai 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	return Result.SUCCESS

func _execute()->int:
	# 道侣一个新人，道侣列表中的所有人之前关系-20
	for id in people.lover_list:
		var other:People = GlobalInfo.get_people_by_id(id)
		if other==null:
			# 对方已经死亡了
			continue
		people.add_relation(other, -20)
	people.lover_list.append(target_people.id)
	target_people.lover_list.append(people.id)
	people.add_relation(target_people,randi_range(10,30))
	return Result.SUCCESS

func get_action_key()->String:
	return "成为道侣"

func _after_execute():
	pass
