extends VBoxContainer

# 一个记录人员id的缓存
var people_id_cache:Array=[]
var place:Place

func _process(delta: float) -> void:
	if place:
		# 如果缓存中的人员id与当前人员id不一致，则更新缓存
		var new_people_id_cache:Array=place.get_all_people().map(func(i:People):return i.id)
		# 比较new_people_id_cache和people_id_cache 如果有一个值不一样，则更新
		if not ArrayUtls.is_equal(new_people_id_cache,people_id_cache):
			_update_people_list()


func init(place:Place):
	self.place=place
	$"VBoxContainer/名称".text=place.name_str
	$"VBoxContainer/地图详情".init(place)

	_update_people_list()
	if GlobalInfo.player.place_id==place.id:
		$"置底操作/进入".hide()
	else:
		$"置底操作/进入".show()

func _update_people_list():
	for i in $"VBoxContainer/所在人员".get_children():
		i.free()
	for i in place.get_all_people():
		# 将人员id加入缓存
		people_id_cache.append(i.id)
		# 创建一个button
		var button=Button.new()
		button.text=i.name_str
		$"VBoxContainer/所在人员".add_child(button)
