class_name PracticeDecision
extends DecisionEntity

func can_do_decision(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	if people.lingqi_absorb_cool_times>0:
		return DecisionEntity.Error("我的灵气还没有消化完，不能再吸收了")
	# 如果当前所在地没有灵气，不修炼
	if GlobalInfo.place_map[people.place_id].current_lin_qi.current<=0:
		return DecisionEntity.Error("当前所在地没有灵气")
	return DecisionEntity.Success()

func get_action_key(dic:Dictionary={})->String:
	return "修炼"

func _after_execute(dic:Dictionary={}):
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	people.action_cool_times=people.action_cool_time.get_current()

func _before_execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	# 如果怀孕了则进行修炼
	if people.is_pregnancy():
		return DecisionEntity.Success()
	if ObjectUtils.probability(95):
		return DecisionEntity.Success()
	return DecisionEntity.Error("我不想修炼")

func _execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	# 修炼
	if people.lingqi.get_current()>=people.lingqi.max_v:
		# 不能吸收灵力了
		if people.can_update():
			# 升级
			people.do_update()
			return DecisionEntity.Success()
		return DecisionEntity.Error("我不想修炼")
	else:
		people.xiu_lian()
		return DecisionEntity.Success()
