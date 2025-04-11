extends Skill


## 由子类实现(技能处理逻辑)
func skill_func(user:PeopleFight,target:PeopleFight,user_team:Array,target_team:Array):
	var target_people=target_team.pick_random()
	var damage=user.people.atk.get_current()
	target_people.people.hp.add_current(-damage)
	target_people.be_attack_animation()
	pass
