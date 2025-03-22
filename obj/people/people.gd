class_name People
extends Action
## 唯一id
var id:String=""
@export var name_str:String=""
## 等级
@export var lv:GrowthPropertie
## 灵气 ，相当于升级所需要的经验
@export var lingqi:BarPropertie
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

func do_action():
	# 年龄计算
	if is_dead():
		if is_player:
			# todo 游戏结束
			return
		GlobalInfo.remove_people(self)
		return
	# 怀孕周期计算
	pregnancy.add_current(1)
	if pregnancy.get_current()>=pregnancy.max_v:
		# todo 生产
		return
	if is_player:
		return
	if action_cool_times>0:
		action_cool_times-=1
		return
	else:
		action_cool_times=action_cool_time.get_current()
	# 恢复
	var 恢复占比=(hp.max_v-hp.get_current())/hp.max_v*100
	if ObjectUtils.probability(恢复占比):
		Log.debug("恢复")
		recover()
		return
	## 修炼判断
	if ObjectUtils.probability(50):
		# 修炼
		if lingqi.get_current()>=lingqi.max_v:
			# 不能吸收灵力了
			if can_update():
				# 升级
				do_update()
				return
		else:
			xiu_lian()
			return
	var place:Place=GlobalInfo.place_map[place_id]
	# 随机选择一个人
	var target_people_list=place.get_other_people_id_list(id)
	if target_people_list.is_empty():
		return
	var target_people:People=GlobalInfo.people_map[target_people_list.pick_random()]
	var weight_1={
		"交好":45,
		"交恶":45,
		"什么都不做":10,
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
		_什么都不做.bind(target_people):weight_1["什么都不做"],
	})
	temp[0].call()
	pass

func _交好(target_people:People):
	Log.debug("交好")
	var weight_1={
		"问好":50,
		"论道":50,
		"切磋":10,
		#待开发"送礼":10,
		"双修":10,
		"拜师":1,
		"成为道侣":10,
		"结婚":10,
		"交配":10,
	}
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
			weight_1["交配"]+=20
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
			weight_1["结婚"]-=10
		lover_list:
			weight_1["双修"]+=10
			weight_1["交配"]+=10
			weight_1["结婚"]+=10
			weight_1["拜师"]-=1
			weight_1["成为道侣"]-=10
		_:
			# 没有深度关系
			pass
	# 怀孕了不能做
	if !target_people.is_man:
		if target_people.pregnancy.get_current()>0:
			weight_1["交配"]=0
			weight_1["双修"]=0
	if !self.is_man:
		if self.pregnancy.get_current()>0:
			weight_1["交配"]=0
			weight_1["双修"]=0
	var action=ObjectUtils.weight_selector(weight_1)[0]
	Log.debug(action)
	match action:
		"问好":
			## 增加关系值
			add_relation(target_people)
			pass
		"论道":
			## 增加关系值
			add_relation(target_people,randi_range(-5,10))
			pass
		"切磋":
			## todo 战斗切磋
			add_relation(target_people,randi_range(-3,6))
			pass
		#"送礼":
			#pass
		"双修":
			# todo 相互之间提示对方当前灵气值的 5%~15%
			add_relation(target_people,randi_range(-1,14))
			pass
		"拜师":
			# todo 如果已经有师傅了，还是要拜师 则原来师傅将对你-100仇恨
			add_relation(target_people,randi_range(5,20))
			pass
		"成为道侣":
			# todo 道侣一个新人，道侣列表中的所有人之前关系-20
			add_relation(target_people,randi_range(10,30))
			pass
		"结婚":
			# todo 结婚一个新人，结婚列表中的所有人之前关系-50
			add_relation(target_people,randi_range(20,40))
			pass
		"交配":
			# todo 如果已经怀孕概率流产
			add_relation(target_people,randi_range(-2,10))
			pass
		_:
			Log.err("没有开发这个操作",action)
	pass
func _交恶(target_people:People):
	Log.debug("交恶")
	var weight_1={
		"攻击":50,
		"辱骂":50,
		#"偷窃":10,
	}
	# todo
	pass
func _什么都不做(target_people:People):
	Log.debug("什么都不做")
	pass

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
	birth=GlobalInfo.game_time
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
	Log.debug("修炼")
	lingqi.add_current(10)
	pass

## 执行升级
func do_update():
	Log.debug("升级")
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
