extends VBoxContainer

var place:Place
var people_id_cache:Array=[]

func _process(delta: float) -> void:
	if place:
		# 如果缓存中的人员id与当前人员id不一致，则更新缓存
		var new_people_id_cache:Array=place.get_all_people().map(func(i:People):return i.id)
		# 比较new_people_id_cache和people_id_cache 如果有一个值不一样，则更新
		if not ArrayUtls.is_equal(new_people_id_cache,people_id_cache):
			update_people_list()

func init(place:Place):
	self.place=place
	update_people_list()
	$"HBoxContainer/地图详情".init(place)

func update_people_list():
	for i in $"HBoxContainer/VBoxContainer/VBoxContainer2/人员".get_children():
		i.free()
	for i in place.get_all_people():
		# 将人员id加入缓存
		people_id_cache.append(i.id)
		# 创建一个button
		var button=Button.new()
		button.text=i.name_str
		$"HBoxContainer/VBoxContainer/VBoxContainer2/人员".add_child(button)
		# 绑定点击事件到change_tips
		button.pressed.connect(_show_detail.bind(i))

	
func _show_detail(people:People):
	GlobalInfo.main_node.change_tips("人员点击tips",people)
	pass
