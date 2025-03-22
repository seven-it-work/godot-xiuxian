extends GutTest

## 测试怀孕概率
func test_calculate_abortion_probability():
	var p=People.new()
	print(p._calculate_abortion_probability())
	pass
