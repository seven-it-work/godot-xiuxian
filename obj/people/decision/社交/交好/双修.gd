class_name DoubleXiuDecision
extends DecisionEntity

var abortion_decision:AbortionDecision=AbortionDecision.new()

func _before_execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var target_people:People=dic.get("target_people")
	# 如果说target_people是玩家 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return DecisionEntity.Error("对象是玩家")
	
	# 15岁以下，越小越不愿意交配
	if target_people.get_age("year")<15 && ObjectUtils.probability(target_people.get_age("year"),15):
		# 对方拒绝了
		return DecisionEntity.Error("我还太小了，我不愿意")
	# 对方如果怀孕了，模拟流产概率计算，如果流产了则不进行校验
	if target_people.is_pregnancy():
		if AbortionDecision.calculate_abortion_probability(target_people) || ObjectUtils.probability(70,100):
			# 对方拒绝了
			return DecisionEntity.Error("我怀孕中，不想那个~")
	return DecisionEntity.Success()
	
func _execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var target_people=dic.get("target_people")
	# 相互之间提升对方当前灵气值的 5%~15%
	var lingqi_percentage = randf_range(0.05, 0.15) * people.lingqi.get_current()
	target_people.lingqi.add_current(lingqi_percentage)
	people.lingqi.add_current(lingqi_percentage)
	
	# 如果 people 或者 target_people 怀孕则进行流产概率计算，如果触发流产则进行流产方法调用
	if people.is_pregnancy():
		abortion_decision.execute(dic)
	if target_people.is_pregnancy():
		abortion_decision.execute(dic)
	return DecisionEntity.Success()

func get_action_key(dic:Dictionary={})->String:
	return "双修"

func _after_execute(dic:Dictionary={}):
	pass
