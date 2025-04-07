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
## 最大寿命 （天为单位），这里没有用current改为birth来计算年龄
@export var max_life:BarPropertie
## 出生时间
@export var birth:float=0;
## 动作速度 （执行动作的冷却时间）
@export var action_cool_time:RandomPropertie;
## 冷却计数器
var action_cool_times:int=0;
var is_fight:bool=false
## 魅力(todo 目前没有用)
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
## 怀孕周期 （天为单位一般是280天）
@export var pregnancy:BarPropertie
## 已经怀孕次数
@export var pregnancy_times:int=0;
# 最大怀孕次数
const MAX_PREGNANCY_COUNT:float = 10.0
## 这个是怀孕的people
@export var pregnancy_people:People
## 战斗逃跑概率
@export var fight_escape_probability:RandomPropertie

#### 这下面是决策
var recovery_decision:RecoveryDecision
var practice_decision:PracticeDecision
var social_decision:SocialDecision
var move_decision:MoveDecision
var abortion_decision:AbortionDecision

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
			ProduceChildrenDecision.new(self).execute()
			return
		else:
			# 概率流产计算
			if abortion_decision==null:
				abortion_decision=AbortionDecision.new(self)
			if abortion_decision.execute()==DecisionEntity.Result.SUCCESS:
				action_cool_times=action_cool_time.get_current()
			return
			pass
	if action_cool_times>0:
		action_cool_times-=1
		return
	if lingqi_absorb_cool_times>0:
		lingqi_absorb_cool_times-=1
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
	# 还可以在此地留传承 接受传承
	## 随机50~90的概率进行移动
	if move_decision==null:
		move_decision=MoveDecision.new(self)
	if move_decision.execute()==DecisionEntity.Result.SUCCESS:
		return
	# 什么都不做
	pass

# 击败他人的后续策略动作方法
func _after_beat(target:People):
	# todo 后续可以更具对方击败策略去做扩展
	# 可以选的操作 放过、击杀、炉鼎、只没收物品
	
	#可以更具对方直系亲属能力综合评估是否击杀
	#通过对方性别 以及魅力、当前灵力属性、对方执行亲属能力判定
	
	# 通过概率计算工具ObjectUtils.probability计算是否击杀他人
	# print(GlobalInfo.people_map.values().size(),GlobalInfo.game_setting["最大人口数"])
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
	if !pregnancy_people:
		return false
	return pregnancy.get_current()>0



## 移动到其它地方
func move_to(place:Place):
	# 从当前地点离开
	GlobalInfo.place_map[place_id].outgoing(self)
	# 进入新地点
	place.enter(self)

## 获得当前年龄 (天)
func get_age(unit:String="day")->int:
	var re=GlobalInfo.game_time-self.birth
	if unit=="day":
		return re
	elif unit=="year":
		return re/365
	return re

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
	# print(self.name_str,re)
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
		"fight_escape_probability":ObjectUtils.obj_2_json(fight_escape_probability),
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
	fight_escape_probability=ObjectUtils.json_2_obj(json["fight_escape_probability"])
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

## 获得当前人员所在地对象
func current_place()->Place:
	return GlobalInfo.place_map[place_id]

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
