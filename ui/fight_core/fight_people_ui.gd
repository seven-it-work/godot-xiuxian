extends PanelContainer

var people_obj:PeopleObj

func _process(delta):
	if people_obj:
		$VBoxContainer/hp.value=people_obj.hp.current_value
		$VBoxContainer/hp.min_value=people_obj.hp.min_v
		$VBoxContainer/hp.max_value=people_obj.hp.max_v

func init(p:PeopleObj):
	people_obj=p
	
	pass
