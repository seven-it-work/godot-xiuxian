extends PanelContainer

var weapon:Weapon

func init(w:Weapon):
	self.weapon=w
	$"VBoxContainer/名称".text="名称：%s"%w.name_str
	var lv_text="等级：%d"%w.lv.get_current()
	if w.intensify.get_current()>0:
		lv_text+="(+%d)"%w.intensify.get_current()
	$"VBoxContainer/等级".text=lv_text
	$"VBoxContainer/描述".text=w.description
	$"VBoxContainer/战力".text="战力：%s"%w.get_score()
	if w.hp.get_current()!=0:
		$"VBoxContainer/生命值".text="生命值：%s"%w.hp.get_current()
	else:
		$"VBoxContainer/生命值".hide()
	if w.atk.min_v+w.atk.max_v!=0:
		$"VBoxContainer/攻击力".propertie=w.atk
	else:
		$"VBoxContainer/攻击力".hide()
	if w.def.min_v+w.def.max_v!=0:
		$"VBoxContainer/防御力".propertie=w.def
	else:
		$"VBoxContainer/防御力".hide()
	pass
