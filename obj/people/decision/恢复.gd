class_name RecoveryDecision
extends DecisionEntity

@onready var people:People

func _init(people:People):
	self.people=people

func get_action_key()->String:
	return "恢复"

func _before_execute()->int:
	var recovery_rate=(people.hp.max_v-people.hp.get_current())/people.hp.max_v*100
	if ObjectUtils.probability(recovery_rate):
		return Result.SUCCESS
	return Result.FAILURE

func _after_execute():
	people.action_cool_times=people.action_cool_time.get_current()

func _execute()->int:
	people.recover()
	return Result.SUCCESS
