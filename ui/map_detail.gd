extends VBoxContainer

var mapObj:MapObj

func init(mapObj:MapObj):
	self.mapObj=mapObj
	initPeopleList()
	
	initMasterList()
	pass
	

func initMasterList():
	for i in $MasterList.get_children():
		i.free()
	for i in self.mapObj.master_list:
		var b=Button.new()
		b.text=i.name_str
		$MasterList.add_child(b)
	pass

func initPeopleList():
	for i in $PeopleList.get_children():
		i.free()
	for i in mapObj.people_dic.values():
		var label=Label.new()
		label.text=i.name_str
		$PeopleList.add_child(label)
	pass
