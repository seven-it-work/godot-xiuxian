class_name MarriageDecision
extends DecisionEntity


func _before_execute(dic:Dictionary={})->Dictionary:
	if !dic.has("people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return DecisionEntity.ErrorCode(-1,"参数错误")
	var target_people=dic.get("target_people")
	# 18岁以下不能结婚
	if target_people.get_age("year")<18:
		return DecisionEntity.Error("我还太小了，我不愿意")
	# 如果target_people是玩家 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return DecisionEntity.Error("对象是玩家")
	# 如果target_people是同性 则返回失败
	if target_people.is_man==people.is_man:
		return DecisionEntity.Error("有没有搞错，我不是同性恋！")
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
	# 结婚一个新人，结婚列表中的所有人之前关系-50
	for id in people.wife_list:
		var other:People = GlobalInfo.get_people_by_id(id)
		if other==null:
			# 对方已经死亡了
			continue
		people.add_relation(other, -50)
	people.wife_list.append(target_people.id)
	target_people.wife_list.append(people.id)
	people.add_relation(target_people,randi_range(20,40))
	return DecisionEntity.Success()

func get_action_key(dic:Dictionary={})->String:
	return "结婚"

func _after_execute(dic:Dictionary={}):
	pass
