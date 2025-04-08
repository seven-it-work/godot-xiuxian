class_name BecomeTeacherDecision
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
	# 如果说target_people是玩家 则加入到GlobalInfo.ai_interaction_queue队列中
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
	# 如果已经有师傅了，还是要拜师 则原来师傅将对你-100仇恨
	if people.shi_fu != "" and people.shi_fu != target_people.id:
		var old_master:People = GlobalInfo.get_people_by_id(people.shi_fu)
		if old_master==null:
			# 师傅已经死亡了
			pass
		else:
			people.add_relation(old_master, -100)
	# 增加关系值
	people.add_relation(target_people, randi_range(5,20))
	# 更新师傅ID
	people.shi_fu = target_people.id
	people.add_relation(target_people,randi_range(5,20))
	return Result.SUCCESS

func get_action_key(dic:Dictionary={})->String:
	return "拜师"

func _after_execute(dic:Dictionary={}):
	pass
