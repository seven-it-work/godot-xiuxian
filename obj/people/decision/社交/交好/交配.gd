class_name MateDecision
extends DecisionEntity

var people:People
var target_people:People

func get_action_key()->String:
	return "交配"

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 15岁以下不能交配
	if target_people.get_age("year")<15:
		return Result.FAILURE
	# 如果说target_people是ai 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	return Result.SUCCESS


func _execute():
	people.add_relation(target_people,randi_range(-2,10))
	if target_people.is_man==people.is_man:
		return Result.SUCCESS
	if !target_people.is_man:
		if target_people._calculate_pregnancy_probability():
			target_people.pregnancy.current=1;
	elif people.is_man:
		if target_people._calculate_pregnancy_probability():
			target_people.pregnancy.current=1;
	return Result.SUCCESS

func _after_execute():
	pass
