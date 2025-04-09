class_name MoveDecision
extends DecisionEntity

func get_action_key(dic:Dictionary={})->String:
	return "移动"

func _before_execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	if people.is_pregnancy():
		# 如果怀孕了，当前地方人越多，就大概移动
		if ObjectUtils.probability(1,people.current_place().get_all_people().size()):
			return DecisionEntity.Error("这里人太多了，我怀孕想去人少的地方")
		return DecisionEntity.Success()
	elif ObjectUtils.probability(randi_range(50,90)):
		return DecisionEntity.Success()
	return DecisionEntity.Error("不想移动")

func _execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	people.move_to(GlobalInfo.place_map.values().pick_random())
	return DecisionEntity.Success()

func _after_execute(dic:Dictionary={}):
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	people.action_cool_times=people.action_cool_time.get_current()
