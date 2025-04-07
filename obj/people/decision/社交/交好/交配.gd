class_name MateDecision
extends DecisionEntity

var people:People
var target_people:People

func get_action_key()->String:
	return "交配"

func _init(people:People,target_people:People):
	self.people=people
	self.target_people=target_people

func _before_execute()->int:
	# 如果说target_people是ai 则加入到GlobalInfo.ai_interaction_queue队列中
	if target_people.is_player:
		GlobalInfo.ai_interaction_queue.append(self)
		return Result.FAILURE
	
	# 15岁以下，越小越不愿意交配
	if ObjectUtils.probability(target_people.get_age("year"),15):
		# 对方拒绝了
		return Result.FAILURE
	# 对方如果怀孕了，模拟流产概率计算，如果流产了则不进行校验
	if target_people.is_pregnancy():
		if AbortionDecision.calculate_abortion_probability(target_people) || ObjectUtils.probability(80,100):
			# 对方拒绝了
			return Result.FAILURE
	return Result.SUCCESS


func _execute():
	people.add_relation(target_people,randi_range(-2,10))
	# 如果 people 或者 target_people 怀孕则进行流产概率计算，如果触发流产则进行流产方法调用
	if people.is_pregnancy():
		if AbortionDecision.new(people).execute()==Result.SUCCESS:
			return Result.SUCCESS
	if target_people.is_pregnancy():
		if AbortionDecision.new(target_people).execute()==Result.SUCCESS:
			return Result.SUCCESS
	
	if target_people.is_man==people.is_man:
		return Result.SUCCESS
	if !target_people.is_man:
		if _calculate_pregnancy_probability(target_people):
			target_people.pregnancy.current=1;
			# 生产孩子胚胎
	elif !people.is_man:
		if _calculate_pregnancy_probability(people):
			people.pregnancy.current=1;
			# 生产孩子胚胎
	return Result.SUCCESS

func _after_execute():
	pass

## 生成新小孩
func _生成新的小孩(father:People,mother:People):
	# 创建一下新的people对象为小孩
	# 将小孩的父母关系添加好
	# 小孩的属性设置
	# 小孩的属性取值公式有两种：
	# 1、区间混合(稳定)
	# max_growth=(father.max_growth+mother.max_growth)/2
	# 然后再上下波动-5%~5%
	# 2、概率择优（波动）
	# 父亲权重=范围(0,1)
	# max_growth=(father.max_growth*父亲权重+mother.max_growth*(1-mother.max_growth))
	# 然后再上下波动-2%~2%
	# 然后再有1%概率突变，突变再上下波动-5%~5%
	pass

# 计算是否怀孕成功
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
