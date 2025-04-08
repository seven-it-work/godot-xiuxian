class_name PregnancyDecision
extends DecisionEntity


func get_action_key(dic:Dictionary={})->String:
	return "怀孕"


func _before_execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	if people.is_pregnancy():
		return Result.FAILURE
	if people.is_man:
		return Result.FAILURE
	return _calculate_pregnancy_probability(people)

func _execute(dic:Dictionary={})->int:
	if !dic.has("people"):
		Log.err("参数错误")
		return Result.FAILURE
	var people=dic.get("people")
	
	if !dic.has("target_people"):
		Log.err("参数错误")
		return Result.FAILURE
	var target_people=dic.get("target_people")

	people.pregnancy.current=1;
	# 生产孩子胚胎
	people.pregnancy_people=_generate_new_child(target_people,people)
	return Result.SUCCESS

func _after_execute(dic:Dictionary={}):
	pass


## 生成新小孩
func _generate_new_child(father:People,mother:People)->People:
	# 创建一下新的people对象为小孩
	var child:People=People.new()
	# 将小孩的父母关系添加好
	child.father=father.id
	child.mother=mother.id
	father.child_list.append(child.id)
	mother.child_list.append(child.id)
	# 小孩的属性设置
	child.lingqi.inherit_parent(father.lingqi,mother.lingqi)
	child.lingqi_absorb_cool_time.inherit_parent(father.lingqi_absorb_cool_time,mother.lingqi_absorb_cool_time)
	child.hp.inherit_parent(father.hp,mother.hp)
	child.atk.inherit_parent(father.atk,mother.atk)
	child.def.inherit_parent(father.def,mother.def)
	child.attack_speed.inherit_parent(father.attack_speed,mother.attack_speed)
	child.max_life.inherit_parent(father.max_life,mother.max_life)
	child.action_cool_time.inherit_parent(father.action_cool_time,mother.action_cool_time)
	child.fight_escape_probability.inherit_parent(father.fight_escape_probability,mother.fight_escape_probability)
	# 孩子随父亲姓
	child.name_str=father.name_str+"_"+mother.name_str
	return child


## 计算是否怀孕成功
# todo 待去测试这个怀孕概率，运行了一段时间概率低的可怕
func _calculate_pregnancy_probability(people:People)->bool:
	# 基础怀孕率
	var pregnancy_probabilty=0.5;
	var age_probabilty=0;
	if people.get_age()<13*365:
	# 如果年龄小于13岁 年龄越小 越不可能
		age_probabilty=min(1,people.get_age()/people.max_life.max_v)
	else:
	# 否则年龄越大，越不可能
		age_probabilty=min(1,1-people.get_age()/people.max_life.max_v)
		# 健康度判断(这个是负向概率，越健康越小)
	var hp_probabilty=1-people.hp.get_current()/people.hp.max_v
	var total_probability=min(1,(pregnancy_probabilty+age_probabilty-hp_probabilty))*100
	Log.dbg("怀孕概率计算信息：",{
			"年龄":people.get_age(),
			"最大年龄":people.max_life.max_v,
			"年龄产生概率":age_probabilty,
		   "健康度":hp_probabilty,
		   "总概率":total_probability
			})
	return ObjectUtils.probability(total_probability);
