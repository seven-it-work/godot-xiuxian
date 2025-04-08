class_name AbortionDecision
extends DecisionEntity

func get_action_key(dic:Dictionary={})->String:
	return "流产"

func _before_execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	if !people.is_pregnancy():
		return Result.FAILURE
	return calculate_abortion_probability(people)

func _after_execute(dic:Dictionary={}):
	pass

func _execute(dic:Dictionary={})->int:
	# todo 流产了，执行流产动作
	return Result.SUCCESS


# 计算是否流产成功
static func calculate_abortion_probability(people:People)->bool:
	# 基础流产概率
	var base_probability = 0
	# 根据怀孕次数增加流产概率
	var pregnancy_count_factor = min(people.pregnancy_times / people.MAX_PREGNANCY_COUNT, 1.0) * 0.003
	# 如果怀孕周期小于100天 那么随着天数增加概率流产
	var pregnancy_weeks_factor = 0
	if people.pregnancy.get_current()<=people.pregnancy.max_v/2:
		pregnancy_weeks_factor=min(people.pregnancy.get_current() / people.pregnancy.max_v, 1.0) * 0.001
	else:
		# 否则概率为随时间增加为-概率（趋于稳定）
		pregnancy_weeks_factor=-(people.pregnancy.get_current()-people.pregnancy.max_v/2)/people.pregnancy.max_v * 0.001
	# 根据年龄增加流产概率
	var age_factor = min(people.get_age() / people.max_life.max_v, 1.0) * 0.002
	# 计算最终流产概率
	var total_probability = base_probability + pregnancy_count_factor + pregnancy_weeks_factor + age_factor
	# 确保概率不超过 1.0
	if ObjectUtils.probability(min(total_probability, 1.0)*100):
		Log.dbg("流产概率计算信息：",{
		"怀孕次数":people.pregnancy_times,
		"怀孕次数产生概率":pregnancy_count_factor,
		"怀孕周期":people.pregnancy.get_current(),
		"怀孕周期产生概率":pregnancy_weeks_factor,
		"年龄":people.get_age(),
		"最大年龄":people.max_life.max_v,
		"年龄产生概率":age_factor,
		"总概率":total_probability,
		})
		return true
	return false
