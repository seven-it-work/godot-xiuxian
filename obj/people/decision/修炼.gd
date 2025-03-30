class_name PracticeDecision
extends DecisionEntity

@onready var people:People

func _init(people:People):
	self.people=people

func get_action_key()->String:
	return "修炼"

func _after_execute():
	people.action_cool_times=people.action_cool_time.get_current()

func _before_execute()->int:
	if people.lingqi_absorb_cool_times>0:
		people.lingqi_absorb_cool_times-=1
		return Result.FAILURE
	if ObjectUtils.probability(50):
		return Result.SUCCESS
	return Result.FAILURE

func _execute()->int:
	# 修炼
	if people.lingqi.get_current()>=people.lingqi.max_v:
		# 不能吸收灵力了
		if people.can_update():
			# 升级
			people.do_update()
			return Result.SUCCESS
	else:
		people.xiu_lian()
		return Result.SUCCESS
	return Result.FAILURE
