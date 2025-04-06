extends Label

func _process(delta: float) -> void:
	# 将游戏时间GlobalInfo.game_time转换为年月日
	var year=GlobalInfo.game_time/365
	var days=GlobalInfo.game_time%365
	var time_dir=Time.get_date_dict_from_unix_time(days*86400)
	var month=time_dir["month"]
	var day=time_dir["day"]
	# 将时间字符串给到时间str这个Label
	self.text=str(year)+"年"+str(month)+"月"+str(day)+"日"
