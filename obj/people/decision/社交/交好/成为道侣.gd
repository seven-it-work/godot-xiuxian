class_name BecomeLoverDecision
extends DecisionEntity

func _before_execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return Result.FAILURE
	var target_people=dic.get("target_people")
	# 15岁以下不能成为道侣
	if target_people.get_age("year")<15:
		return Result.FAILURE
	# 如果说target_people是ai 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	return Result.SUCCESS

func _execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return Result.FAILURE
	var target_people=dic.get("target_people")
	# 道侣一个新人，道侣列表中的所有人之前关系-20
	for id in people.lover_list:
		var other:People = GlobalInfo.get_people_by_id(id)
		if other==null:
			# 对方已经死亡了
			continue
		people.add_relation(other, -20)
	people.lover_list.append(target_people.id)
	target_people.lover_list.append(people.id)
	people.add_relation(target_people,randi_range(10,30))
	return Result.SUCCESS

func get_action_key(dic:Dictionary={})->String:
	return "成为道侣"

func _after_execute(dic:Dictionary={}):
	pass
