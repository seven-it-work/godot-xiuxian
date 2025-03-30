class_name People
extends Action
## 唯一id
var id:String=""
@export var name_str:String=""
## 等级
@export var lv:GrowthPropertie
## 灵气 ，相当于升级所需要的经验
@export var lingqi:BarPropertie
## 吸收灵气量
@export var lingqi_absorb:RandomPropertie
## 吸收灵气冷却时间
@export var lingqi_absorb_cool_time:RandomPropertie
## 吸收灵气冷却计数器
@export var lingqi_absorb_cool_times:float=0
## 生命值
@export var hp:BarPropertie
## 攻击力
@export var atk:RandomPropertie
## 防御力
@export var def:RandomPropertie
## 所在地
@export var place_id:String=""
## 关系信息
@export var relation:Dictionary={}
@export var is_player:bool=false
## 集气速度(战斗中使用)
@export var attack_speed:RandomPropertie;
## 性别
@export var is_man:bool=true
## 最大寿命 （天为单位）
@export var max_life:BarPropertie
## 出生时间
@export var birth:float=0;
## 动作速度 （执行动作的冷却时间）
@export var action_cool_time:RandomPropertie;
## 冷却计数器
var action_cool_times:int=0;
var is_fight:bool=false
## 魅力
@export var charm:int=0;
## 师傅id
@export var shi_fu:String=""
## 父亲id
@export var father:String=""
## 母亲id
@export var mother:String=""
## 妻子id_list
@export var wife_list:Array=[]
## 道侣id_list
@export var lover_list:Array=[]
## 孩子id_list
@export var child_list:Array=[]
## 怀孕周期 （天为单位）
@export var pregnancy:BarPropertie
## 已经怀孕次数
@export var pregnancy_times:int=0;
# 最大怀孕次数
const MAX_PREGNANCY_COUNT:float = 10.0

var recovery_decision:RecoveryDecision
var practice_decision:PracticeDecision
var social_decision:SocialDecision
var move_decision:MoveDecision

func do_action():
	# 年龄计算
	if is_dead():
		if is_player:
			# todo 游戏结束
			return
		GlobalInfo.remove_people(self)
		return
	# 怀孕周期计算
	if is_pregnancy():
		pregnancy.add_current(1)
		if pregnancy.get_current()>=pregnancy.max_v:
			# 每次生产新的人类就往statistics_map中的key为出生人数+1
			GlobalInfo.statistics_map["出生人数"]+=1
			# todo 生产
			action_cool_times=action_cool_time.get_current()
			return
		else:
			# 概率流产计算
			if _calculate_abortion_probability():
				action_cool_times=action_cool_time.get_current()
				return
			pass
	if action_cool_times>0:
		action_cool_times-=1
		return
	if is_player:
		return
	# 恢复
	if recovery_decision==null:
		recovery_decision=RecoveryDecision.new(self)
	if recovery_decision.execute()==DecisionEntity.Result.SUCCESS:
		return
	## 修炼判断
	if practice_decision==null:
		practice_decision=PracticeDecision.new(self)
	if practice_decision.execute()==DecisionEntity.Result.SUCCESS:
		return
	## 社交
	if social_decision==null:
		social_decision=SocialDecision.new(self)
	if social_decision.execute()==DecisionEntity.Result.SUCCESS:
		return
	## 随机50~90的概率进行移动
	if move_decision==null:
		move_decision=MoveDecision.new(self)
	if move_decision.execute()==DecisionEntity.Result.SUCCESS:
		return
	# 什么都不做
	pass
	
	
func _社交()->bool:
	if GlobalInfo.place_map.is_empty():
		return false
	var place:Place=GlobalInfo.place_map[place_id]
	# 随机选择一个人
	var target_people_list=place.get_other_people_id_list(id)
	if target_people_list.is_empty():
		return false
	# 如果target_people_list.pick_random()的随机一个不在relation中，则重新选择
	var target_id=target_people_list.pick_random()
	if !GlobalInfo.people_map.has(target_id):
		# 这里出错了，打印错误信息
		Log.err("社交时，target_id:%s不存在"%target_id,GlobalInfo.people_map)
		return _社交()
	var target_people:People=GlobalInfo.get_people_by_id(target_id)
	if target_people==null:
		return false
	var weight_1={
		"交好":GlobalInfo.game_setting["最大人口数"],
		"交恶":GlobalInfo.people_map.values().size(),
	}
	if relation.has(target_people.id):
		var re=relation.get(target_people.id)
		if re.relation_value>0:
			weight_1["交好"]+=re.relation_value
		else:
			weight_1["交恶"]-=re.relation_value
	var temp=ObjectUtils.weight_selector({
		_交好.bind(target_people):weight_1["交好"],
		_交恶.bind(target_people):weight_1["交恶"],
		# _什么都不做.bind(target_people):weight_1["什么都不做"],
	})
	return temp[0].call()
func _修炼()->bool:
	if lingqi_absorb_cool_times>0:
		lingqi_absorb_cool_times-=1
		return false
	if ObjectUtils.probability(50):
		# 修炼
		if lingqi.get_current()>=lingqi.max_v:
			# 不能吸收灵力了
			if can_update():
				# 升级
				do_update()
				return true
		else:
			xiu_lian()
			return true
	return false
func _恢复()->bool:
	var 恢复占比=(hp.max_v-hp.get_current())/hp.max_v*100
	if ObjectUtils.probability(恢复占比):
		#Log.debug("恢复")
		recover()
		return true
	return false
func _交好(target_people:People)->bool:
	Log.debug(str_format("{name_str} 与 %s 交好 "%target_people.name_str))
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
		shi_fu:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		father:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		mother:
			weight_1["问好"]+=50
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		child_list:
			weight_1["切磋"]+=10
			weight_1["双修"]-=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		wife_list:
			weight_1["双修"]+=10
			weight_1["交配"]+=30
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		lover_list:
			weight_1["双修"]+=10
			weight_1["交配"]+=20
			weight_1["结婚"]+=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
		_:
			# 没有深度关系
			pass
	# 关系值影响
	if relation.has(target_people.id):
		var re:Relation=relation.get(target_people.id)
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
	if !self.is_man:
		if self.pregnancy.get_current()>0:
			weight_1["交配"]-=10
			weight_1["双修"]-=10
	# 如果是同性，双修=0 成为道侣=0 结婚=0 交配=0
	if target_people.is_man==is_man:
		weight_1["交配"]-=10
		weight_1["双修"]-=10
		weight_1["成为道侣"]-=10
		weight_1["结婚"]-=10
	
	var action=ObjectUtils.weight_selector(weight_1)[0]
	Log.debug(str_format("{name_str}执行动作%s"%action),weight_1)
	match action:
		"问好":
			## 增加关系值
			add_relation(target_people)
			return true
		"论道":
			## 增加关系值
			add_relation(target_people,randi_range(-5,10))
			return true
		"切磋":
			## todo 战斗切磋
			add_relation(target_people,randi_range(-3,6))
			return true
		#"送礼":
			#pass
		"双修":
			# 相互之间提升对方当前灵气值的 5%~15%
			var lingqi_percentage = randf_range(0.05, 0.15) * lingqi.get_current()
			target_people.lingqi.add_current(lingqi_percentage)
			lingqi.add_current(lingqi_percentage)
			# 增加关系值
			add_relation(target_people,randi_range(-1,14))
			return true
		"拜师":
			# 如果已经有师傅了，还是要拜师 则原来师傅将对你-100仇恨
			if shi_fu != "" and shi_fu != target_people.id:
				var old_master:People = GlobalInfo.get_people_by_id(shi_fu)
				if old_master==null:
					# 师傅已经死亡了
					pass
				else:
					add_relation(old_master, -100)
			# 增加关系值
			add_relation(target_people, randi_range(5,20))
			# 更新师傅ID
			shi_fu = target_people.id
			add_relation(target_people,randi_range(5,20))
			return true
		"成为道侣":
			# 道侣一个新人，道侣列表中的所有人之前关系-20
			for id in lover_list:
				var other:People = GlobalInfo.get_people_by_id(id)
				if other==null:
					# 对方已经死亡了
					continue
				add_relation(other, -20)
			lover_list.append(target_people.id)
			target_people.lover_list.append(self.id)
			add_relation(target_people,randi_range(10,30))
			return true
		"结婚":
			# 结婚一个新人，结婚列表中的所有人之前关系-50
			for id in wife_list:
				var other:People = GlobalInfo.get_people_by_id(id)
				if other==null:
					# 对方已经死亡了
					continue
				add_relation(other, -50)
			wife_list.append(target_people.id)
			target_people.wife_list.append(self.id)
			add_relation(target_people,randi_range(20,40))
			return true
		"交配":
			add_relation(target_people,randi_range(-2,10))
			if target_people.is_man==is_man:
				return true
			if !target_people.is_man:
				if target_people._calculate_pregnancy_probability():
					target_people.pregnancy.current=1;
			elif is_man:
				if _calculate_pregnancy_probability():
					pregnancy.current=1;
			return true
		_:
			Log.err("没有开发这个操作",action)
	return false
func _交恶(target_people:People)->bool:
	Log.debug(str_format("{name_str} 与 %s 交恶 "%target_people.name_str))
	var weight_1={
		"攻击":GlobalInfo.people_map.values().size(),
		"辱骂":GlobalInfo.game_setting["最大人口数"],
		#"偷窃":10,
	}
	# 使用ObjectUtils.weight_selector权重选择器对weight_1进行选择
	var action=ObjectUtils.weight_selector(weight_1)[0]
	Log.debug(str_format("{name_str}执行动作%s"%action),weight_1)
	match action:
		"攻击":
			# 调用self和target的集气速度
			var self_speed=attack_speed.get_current()
			var target_speed=target_people.attack_speed.get_current()
			while true:
				# slef_speed-1
				self_speed-=1
				# target_speed-1
				target_speed-=1
				# 如果self_speed<=0 则self攻击target
				if self_speed<=0:
					do_attack(target_people)
					# 重置self_speed
					self_speed=attack_speed.get_current()
				if target_speed<=0:
					target_people.do_attack(self)
					# 重置target_speed
					target_speed=target_people.attack_speed.get_current()
				# 如果self的生命值或者targbet的生命值小于0退出循环
				if hp.get_current()<=0 or target_people.hp.get_current()<=0:
					break
			# 如果self的生命值小于0，则战斗失败
			if hp.get_current()<=0:
				target_people._after_beat(self)
			# 如果target_people的生命值小于0，则战斗胜利
			if target_people.hp.get_current()<=0:
				_after_beat(target_people)
			return true
		"辱骂":
			return true
		_:
			Log.err("没有开发这个操作",action)
	return false

# func _什么都不做(target_people:People):
# 	Log.debug("什么都不做")
# 	return false

# 击败他人的后续策略动作方法
func _after_beat(target:People):
	# todo 后续可以更具对方击败策略去做扩展
	# 通过概率计算工具ObjectUtils.probability计算是否击杀他人
	print(GlobalInfo.people_map.values().size(),GlobalInfo.game_setting["最大人口数"])
	if ObjectUtils.probability(GlobalInfo.people_map.values().size(),GlobalInfo.game_setting["最大人口数"]):
		# 记录日志
		Log.debug("击杀他人",{
			"source":self.name_str,
			"target":target.name_str,
			"source_id":self.id,
			"target_id":target.id,
		})
		# 击杀他人
		kill(target)
	else:
		target.hp.current=1
	pass


# 判断是否怀孕
func is_pregnancy()->bool:
	return pregnancy.get_current()>0

# 计算是否怀孕成功
func _calculate_pregnancy_probability()->bool:
	# 基础怀孕率
	var pregnancy_probabilty=0.5;
	var age_probabilty=0;
	if get_age()<13*365:
	# 如果年龄小于13岁 年龄越小 越不可能
		age_probabilty=min(1,get_age()/max_life.max_v)
	else:
	# 否则年龄越大，越不可能
		age_probabilty=min(1,1-get_age()/max_life.max_v)
	# 健康度判断(这个是负向概率，越健康越小)
	var hp_probabilty=1-hp.get_current()/hp.max_v
	var total_probability=min(1,(pregnancy_probabilty+age_probabilty-hp_probabilty))*100
	Log.dbg("怀孕概率计算信息：",{
		"年龄":get_age(),
		"最大年龄":max_life.max_v,
		"年龄产生概率":age_probabilty,
		"健康度":hp_probabilty,
		"总概率":total_probability
	})
	return ObjectUtils.probability(total_probability);
# 计算是否流产成功
func _calculate_abortion_probability()->bool:
	# 基础流产概率
	var base_probability = 0
	# 根据怀孕次数增加流产概率
	var pregnancy_count_factor = min(pregnancy_times / MAX_PREGNANCY_COUNT, 1.0) * 0.003
	# 如果怀孕周期小于100天 那么随着天数增加概率流产
	var pregnancy_weeks_factor = 0
	if pregnancy.get_current()<=pregnancy.max_v/2:
		pregnancy_weeks_factor=min(pregnancy.get_current() / pregnancy.max_v, 1.0) * 0.001
	else:
		# 否则概率为随时间增加为-概率（趋于稳定）
		pregnancy_weeks_factor=-(pregnancy.get_current()-pregnancy.max_v/2)/pregnancy.max_v * 0.001
	# 根据年龄增加流产概率
	var age_factor = min(get_age() / max_life.max_v, 1.0) * 0.002
	# 计算最终流产概率
	var total_probability = base_probability + pregnancy_count_factor + pregnancy_weeks_factor + age_factor
	# 确保概率不超过 1.0
	if ObjectUtils.probability(min(total_probability, 1.0)*100):
		Log.dbg("流产概率计算信息：",{
		"怀孕次数":pregnancy_times,
		"怀孕次数产生概率":pregnancy_count_factor,
		"怀孕周期":pregnancy.get_current(),
		"怀孕周期产生概率":pregnancy_weeks_factor,
		"年龄":get_age(),
		"最大年龄":max_life.max_v,
		"年龄产生概率":age_factor,
		"总概率":total_probability,
		})
		return true
	return false

## 移动到其它地方
func move_to(place:Place):
	# 从当前地点离开
	GlobalInfo.place_map[place_id].outgoing(self)
	# 进入新地点
	place.enter(self)

## 获得当前年龄 (天)
func get_age()->int:
	return GlobalInfo.game_time-self.birth


## 是否死亡
func is_dead()->bool:
	# 判断 GlobalInfo.game_time 和 birth 的时间差（天）
	# 然后将这个作为年龄（多少天）然后与max_life.max_v进行比较，如果年龄大 则死亡
	return hp.get_current()<=0;

## 创建新的关系
func _add_new_relation(target:People):
	var re=Relation.create_relation(self.id,target.id)
	relation[target.id]=re;
	target.relation[self.id]=re;

## 添加关系
func add_relation(target:People,n:int=5):
	if relation.has(target.id):
		relation[target.id].add_relation(n)
	else:
		_add_new_relation(target)
		self.add_relation(target,n)

func _init() -> void:
	self.load_json(JSON.parse_string(FileAccess.open("res://obj/people/people.json",FileAccess.READ).get_as_text()))
	id=uuid.v4()
	#birth=GlobalInfo.game_time
	pass

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass



## 对目标执行攻击
func do_attack(target:People):
	var damge=self.atk.get_current()
	target.hp.add_current(-damge)
	pass

## 回血回复
func recover():
	var 单次恢复量=10
	self.hp.add_current(单次恢复量)
	pass

## 修炼
func xiu_lian():
	lingqi_absorb_cool_times=lingqi_absorb_cool_time.get_current()
	#Log.debug("修炼")
	lingqi.add_current(lingqi_absorb.get_current())
	pass

## 执行升级
func do_update():
	#Log.debug("升级")
	self.lv.add_current(1)
	var c_list=$SubViewport.get_children()
	self.lingqi.random_add_growth(self.lv.get_current())
	for i in c_list:
		if i is GrowthPropertie:
			i.do_growth()
	self.lingqi.current=0
	pass

## 是否能升级
func can_update()->bool:
	return self.lingqi.get_current()==self.lingqi.max_v

## 获得战斗能力值
func get_combat_capability()->float:
	var re=0;
	re+=hp.current*0.3
	const 风险系数=0.1
#	攻击力：战力=（max+min）/2/(1+0.1*pow((max-min))/12
	re+=atk.get_current_score()*0.3
	re+=def.get_current_score()*0.2
	print(self.name_str,re)
	return re;

## 进行判断是否能进行攻击（一般ai使用）
func can_attack(target:People)->bool:
	# 基础概率（一般50% 越好斗越接近100%）
	var base=0.9
	var self_p=self.get_combat_capability()
	var target_p=target.get_combat_capability()
	var p=0
	var dif=abs(target_p-self_p)/(self_p+target_p)
	if self_p>=target_p:
		p=base+dif
	else:
		p=base-dif
	var probability=clamp(p,0,1)
	print("{source}({self_p})攻击{target}({target_p})的概率为：{probability}".format({
		"source":self.name_str,
		"self_p":self_p,
		"target":target.name_str,
		"target_p":target_p,
		"probability":probability
	}))
	return ObjectUtils.probability(probability*100)

func save_relation_json()->Dictionary:
	var re={}
	for i in relation:
		re[i]=relation[i].save_json();
	return re

func save_json():
	var re:Dictionary={}
	re.merge({
		"filename" : "res://obj/people/People.tscn",
		"id":self.id,
		"name_str":self.name_str,
		"lv":ObjectUtils.obj_2_json(lv),
		"lingqi":ObjectUtils.obj_2_json(lingqi),
		"hp":ObjectUtils.obj_2_json(hp),
		"atk":ObjectUtils.obj_2_json(atk),
		"def":ObjectUtils.obj_2_json(def),
		"place_id":self.place_id,
		"relation":ObjectUtils.obj_2_json(relation),
		"is_player":self.is_player,
		"attack_speed":ObjectUtils.obj_2_json(attack_speed),
		"is_man":is_man,
		"max_life":ObjectUtils.obj_2_json(max_life),
		"action_cool_time":ObjectUtils.obj_2_json(action_cool_time),
		"birth":birth,
		"is_fight":is_fight,
		"charm":charm,
		"shi_fu":shi_fu,
		"father":father,
		"mother":mother,
		"wife_list":ObjectUtils.obj_2_json(wife_list),
		"lover_list":ObjectUtils.obj_2_json(lover_list),
		"child_list":ObjectUtils.obj_2_json(child_list),
		"pregnancy":ObjectUtils.obj_2_json(pregnancy),
		"lingqi_absorb":ObjectUtils.obj_2_json(lingqi_absorb),
		"lingqi_absorb_cool_time":ObjectUtils.obj_2_json(lingqi_absorb_cool_time),
		"lingqi_absorb_cool_times":lingqi_absorb_cool_times,
	},true)
	return re
	
func load_json(json:Dictionary):
	id=json["id"]
	name_str=json["name_str"]
	lv=ObjectUtils.json_2_obj(json["lv"])
	lingqi=ObjectUtils.json_2_obj(json["lingqi"])
	hp=ObjectUtils.json_2_obj(json["hp"])
	atk=ObjectUtils.json_2_obj(json["atk"])
	def=ObjectUtils.json_2_obj(json["def"])
	place_id=json["place_id"]
	relation=ObjectUtils.json_2_obj(json["relation"])
	is_player=json["is_player"]
	attack_speed=ObjectUtils.json_2_obj(json["attack_speed"])
	is_man=json["is_man"]
	max_life=ObjectUtils.json_2_obj(json["max_life"])
	action_cool_time=ObjectUtils.json_2_obj(json["action_cool_time"])
	birth=json["birth"]
	is_fight=json["is_fight"]
	charm=json["charm"]
	shi_fu=json["shi_fu"]
	father=json["father"]
	mother=json["mother"]
	wife_list=json["wife_list"]
	lover_list=json["lover_list"]
	child_list=json["child_list"]
	pregnancy=ObjectUtils.json_2_obj(json["pregnancy"])
	lingqi_absorb=ObjectUtils.json_2_obj(json["lingqi_absorb"])
	lingqi_absorb_cool_time=ObjectUtils.json_2_obj(json["lingqi_absorb_cool_time"])
	lingqi_absorb_cool_times=json["lingqi_absorb_cool_times"]

## 击杀他人
func kill(target:People):
	GlobalInfo.remove_people(target)
	# todo target情侣仇恨+50 父母+100 儿子+50
	# todo 获得物品
	pass

## 炉鼎他人
func lu_ding(target:People):
	# 将他人当前灵气的15~25%给到自己
	var lin=randf_range(0.15,0.25)*target.lingqi.get_current()
	lingqi.add_current(lin)
	GlobalInfo.remove_people(target)
	# todo target情侣仇恨+25 父母+50 儿子+25
	pass

## 日志输出辅助方法
func str_format(msg:String)->String:
	var data=save_json()
	var result:=msg;
	var regex:=RegEx.new()
	regex.compile("\\{([^}]+)\\}")
	for match in regex.search_all(msg):
		var placeholder:=match.get_string()
		var key_path:=match.get_string(1)
		# 字典中取值
		var value=ObjectUtils.get_nested_value(data,key_path)
		if value!=null:
			result=result.replace(placeholder,str(value))
	return result
