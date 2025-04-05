class_name SocialGoodDecision
extends DecisionEntity

@onready var people:People
@onready var target_people:People

func get_action_key()->String:
	return "交好"

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	return Result.SUCCESS

func _execute()->int:
	Log.debug(people.name_str+" 与 "+target_people.name_str+" 交好 ")
	var weight_1={
		"问好":70,
		"论道":50,
		"切磋":30,
		#待开发"送礼":10,
		"双修":10,
		"拜师":10,
		"成为道侣":10,
		"结婚":10,
		"交配":10,
	}
	# 特殊关系影响
	match target_people.id:
		people.shi_fu:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.father:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.mother:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.child_list:
			weight_1["切磋"]+=10
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.wife_list:
			weight_1["双修"]+=10
			weight_1["交配"]+=30
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		people.lover_list:
			weight_1["双修"]+=10
			weight_1["交配"]+=20
			weight_1["结婚"]+=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
		_:
			# 没有深度关系
			pass
	# 关系值影响
	if people.relation.has(target_people.id):
		var re:Relation=people.relation.get(target_people.id)
		weight_1["问好"]+=re.relation_value*0.1
		weight_1["论道"]+=re.relation_value*0.1
		weight_1["切磋"]+=re.relation_value*0.1
		weight_1["双修"]+=re.relation_value*0.5
		weight_1["拜师"]+=re.relation_value*0.1
		weight_1["成为道侣"]+=re.relation_value*0.4
		weight_1["结婚"]+=re.relation_value*0.3
		weight_1["交配"]+=re.relation_value*0.2
	# 怀孕了不能做
	if !target_people.is_man:
		if target_people.pregnancy.get_current()>0:
			weight_1["交配"]-=10
			weight_1["双修"]-=10
	if !people.is_man:
		if people.pregnancy.get_current()>0:
			weight_1["交配"]-=10
			weight_1["双修"]-=10
	# 如果是同性，双修=0 成为道侣=0 结婚=0 交配=0
	if target_people.is_man==people.is_man:
		weight_1["交配"]-=10
		weight_1["双修"]-=10
		weight_1["成为道侣"]-=10
		weight_1["结婚"]-=10
	
	var action=ObjectUtils.weight_selector(weight_1)[0]
	Log.debug(people.name_str+"执行动作"+action,weight_1)
	match action:
		"问好":
			## 增加关系值
			people.add_relation(target_people)
			return Result.SUCCESS
		"论道":
			## 增加关系值
			people.add_relation(target_people,randi_range(-5,10))
			return Result.SUCCESS
		"切磋":
			## todo 战斗切磋
			people.add_relation(target_people,randi_range(-3,6))
			return Result.SUCCESS
		#"送礼":
			#pass
		"双修":
			# 相互之间提升对方当前灵气值的 5%~15%
			var lingqi_percentage = randf_range(0.05, 0.15) * people.lingqi.get_current()
			target_people.lingqi.add_current(lingqi_percentage)
			people.lingqi.add_current(lingqi_percentage)
			# 增加关系值
			people.add_relation(target_people,randi_range(-1,14))
			return Result.SUCCESS
		"拜师":
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
		"成为道侣":
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
		"结婚":
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
			return Result.SUCCESS
		"交配":
			people.add_relation(target_people,randi_range(-2,10))
			if target_people.is_man==people.is_man:
				return Result.SUCCESS
			if !target_people.is_man:
				if target_people._calculate_pregnancy_probability():
					target_people.pregnancy.current=1;
			elif people.is_man:
				if target_people._calculate_pregnancy_probability():
					target_people.pregnancy.current=1;
			return Result.SUCCESS
		_:
			Log.err("没有开发这个操作",action)
	return Result.SUCCESS

func _after_execute():
	people.action_cool_times=people.action_cool_time.get_current()
