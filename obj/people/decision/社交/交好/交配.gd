class_name 交配 extends DecisionEntity
func _init():
	pass
func _before_execute():
	pass


func _execute():
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
	pass
func _after_execute():
	pass
