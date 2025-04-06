class_name DoubleXiuDecision
extends DecisionEntity

var people:People
var target_people:People

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 15岁以下不能双修
	if target_people.get_age("year")<15:
		return Result.FAILURE
	# 如果说target_people是玩家 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	return Result.SUCCESS

func _execute()->int:
	# 相互之间提升对方当前灵气值的 5%~15%
	var lingqi_percentage = randf_range(0.05, 0.15) * people.lingqi.get_current()
	target_people.lingqi.add_current(lingqi_percentage)
	people.lingqi.add_current(lingqi_percentage)
	return Result.SUCCESS

func get_action_key()->String:
	return "双修"

func _after_execute():
	pass






