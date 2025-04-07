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
	# 如果说target_people是ai 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	
	# 15岁以下，越小越不愿意交配
	if ObjectUtils.probability(target_people.get_age("year"),15):
		# 对方拒绝了
		return Result.FAILURE
	# 对方如果怀孕了，模拟流产概率计算，如果流产了则不进行校验
	if target_people.is_pregnancy():
		if AbortionDecision.calculate_abortion_probability(target_people) || ObjectUtils.probability(80,100):
			# 对方拒绝了
			return Result.FAILURE
	return Result.SUCCESS


func _execute():
	people.add_relation(target_people,randi_range(-2,10))
	# 如果 people 或者 target_people 怀孕则进行流产概率计算，如果触发流产则进行流产方法调用
	if people.is_pregnancy():
		if AbortionDecision.new(people).execute()==Result.SUCCESS:
			return Result.SUCCESS
	if target_people.is_pregnancy():
		if AbortionDecision.new(target_people).execute()==Result.SUCCESS:
			return Result.SUCCESS
	
	if target_people.is_man==people.is_man:
		return Result.SUCCESS
	
	if !target_people.is_man:
		return PregnancyDecision.new(target_people,people).execute()
	elif !people.is_man:
		return PregnancyDecision.new(people,target_people).execute()
	return Result.SUCCESS

func _after_execute():
	pass
