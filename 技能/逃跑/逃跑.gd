extends Skill


## 由子类实现(技能处理逻辑)
func skill_func(user:PeopleFight,target:PeopleFight,user_team:Array,target_team:Array):
	var p=user.people.fight_escape_probability.get_current()
	if ObjectUtils.probability(p):
		# todo 逃跑成功
		GlobalInfo.main_node.fight_over(
			{
				"people":user.people,
				"type":"逃跑成功"
			})
		return
	Log.info("逃跑失败了",[user.people.name_str,"概率%s"%p])
	pass
