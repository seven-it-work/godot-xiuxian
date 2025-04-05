class_name MoveDecision
extends DecisionEntity

@onready var people:People

func _init(people:People):
	self.people=people

func get_action_key()->String:
	return "移动"

func _before_execute()->int:
	if ObjectUtils.probability(randi_range(50,90)):
		return Result.SUCCESS
	return Result.FAILURE

func _execute()->int:
	people.move_to(GlobalInfo.place_map.values().pick_random())
	return Result.SUCCESS

func _after_execute():
	people.action_cool_times=people.action_cool_time.get_current()
