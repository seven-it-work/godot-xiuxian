extends GutTest

## 测试怀孕概率
func test_calculate_abortion_probability():
	var p=preload("res://obj/people/People.tscn").instantiate()
	p.pregnancy_times=3
	for i in p.pregnancy.max_v:
		p.do_action()
	print("正常")
	pass

## 测试自动格式
func test_auto_format_people():
	var p=preload("res://obj/people/People.tscn").instantiate()
	p.name_str="测试"
	p.lv.current=10
	assert_eq("我是"+p.name_str,p.str_format("我是{name_str}"))
	assert_eq("我的等级是10.0级",p.str_format("我的等级是{lv.current}级"))
	print(p.save_json())
