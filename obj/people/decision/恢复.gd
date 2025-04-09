class_name RecoveryDecision
extends DecisionEntity

func get_action_key(dic:Dictionary={})->String:
	return "恢复"

func _before_execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	var recovery_rate=(people.hp.max_v-people.hp.get_current())/people.hp.max_v*100
	if ObjectUtils.probability(recovery_rate):
		return DecisionEntity.Success()
	# 如果已经怀孕，则生命值不满时就恢复
	if people.is_pregnancy() && people.hp.get_current()<people.hp.max_v:
		return DecisionEntity.Success()
	return DecisionEntity.Error("不想恢复")

func _after_execute(dic:Dictionary={}):
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	people.action_cool_times=people.action_cool_time.get_current()

func _execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	people.recover()
	return DecisionEntity.Success()
