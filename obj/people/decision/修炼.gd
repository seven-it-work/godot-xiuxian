class_name PracticeDecision
extends DecisionEntity

func get_action_key(dic:Dictionary={})->String:
	return "修炼"

func _after_execute(dic:Dictionary={}):
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	people.action_cool_times=people.action_cool_time.get_current()

func _before_execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	if people.lingqi_absorb_cool_times>0:
		return Result.FAILURE
	if ObjectUtils.probability(50):
		return Result.SUCCESS
	# 如果怀孕了则进行修炼
	if people.is_pregnancy():
		return Result.SUCCESS
	return Result.FAILURE

func _execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	# 修炼
	if people.lingqi.get_current()>=people.lingqi.max_v:
		# 不能吸收灵力了
		if people.can_update():
			# 升级
			people.do_update()
			return Result.SUCCESS
	else:
		people.xiu_lian()
		return Result.SUCCESS
	return Result.FAILURE
