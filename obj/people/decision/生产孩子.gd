class_name ProduceChildrenDecision
extends DecisionEntity

@onready var people:People

func _init(people:People):
	self.people=people

func get_action_key()->String:
	return "生产孩子"

func _before_execute()->int:
	if !people.is_pregnancy():
		return Result.FAILURE
	return Result.SUCCESS

func _after_execute():
	people.action_cool_times=people.action_cool_time.get_current()

func _execute()->int:
	_生产孩子(people)
	return Result.SUCCESS

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
	var place:Place=GlobalInfo.place_map[self.place_id]
	place.enter(people.pregnancy_people)
	# 将孩子加入到 GlobalInfo.people_map 中
	GlobalInfo.people_map[people.pregnancy_people.id]=people.pregnancy_people
	people.pregnancy_people=null
	pass
