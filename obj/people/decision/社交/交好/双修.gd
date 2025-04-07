class_name DoubleXiuDecision
extends DecisionEntity

var people:People
var target_people:People

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 如果说target_people是玩家 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	
	# 15岁以下，越小越不愿意交配
	if ObjectUtils.probability(target_people.get_age("year"),15):
		# 对方拒绝了
		return Result.FAILURE
	# 对方如果怀孕了，模拟流产概率计算，如果流产了则不进行校验
	if target_people.is_pregnancy():
		if AbortionDecision.calculate_abortion_probability(target_people) || ObjectUtils.probability(70,100):
			# 对方拒绝了
			return Result.FAILURE
	return Result.SUCCESS

func _execute()->int:
	# 相互之间提升对方当前灵气值的 5%~15%
	var lingqi_percentage = randf_range(0.05, 0.15) * people.lingqi.get_current()
	target_people.lingqi.add_current(lingqi_percentage)
	people.lingqi.add_current(lingqi_percentage)
	
	# 如果 people 或者 target_people 怀孕则进行流产概率计算，如果触发流产则进行流产方法调用
	if people.is_pregnancy():
		AbortionDecision.new(people).execute()
	if target_people.is_pregnancy():
		AbortionDecision.new(target_people).execute()
	return Result.SUCCESS

func get_action_key()->String:
	return "双修"

func _after_execute():
	pass
