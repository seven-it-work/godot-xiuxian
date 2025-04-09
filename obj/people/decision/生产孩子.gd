class_name ProduceChildrenDecision
extends DecisionEntity


func get_action_key(dic:Dictionary={})->String:
	return "生产孩子"

func _before_execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	if !people.is_pregnancy():
		return DecisionEntity.Error("我都没有怀孕，怎么生孩子")
	return DecisionEntity.Success()

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
	_生产孩子(people)
	return DecisionEntity.Success()

func _生产孩子(people:People):
	if !people.is_pregnancy():
		return
	# 如果 pregnancy_people 存在表示有怀孩子，否则直接返回
	
	# 难产概率判定，pregnancy.current 越远离 pregnancy.max_v 越概率难产
	if !ObjectUtils.probability(people.pregnancy.get_current(),people.pregnancy.max_v):
		# 难产了
		# 1.孩子丢失 pregnancy_people 丢失
		# 2.随机扣除生命值（0，hp.max_v/2）的随机值
		pass
	
	# 孩子出生成功。设置孩子属性
	people.pregnancy_people.birth=GlobalInfo.game_time
	# 孩子进入母亲所在地
	var place:Place=GlobalInfo.place_map[people.place_id]
	place.enter(people.pregnancy_people)
	# 将孩子加入到 GlobalInfo.people_map 中
	GlobalInfo.people_map[people.pregnancy_people.id]=people.pregnancy_people
	people.pregnancy.current=0
	people.pregnancy_people=null
	pass
