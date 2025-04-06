@tool
class_name  ArrayUtls

# 判断两个数组是否相等
static func is_equal(arr1:Array,arr2:Array)->bool:
	if arr1.size()!=arr2.size():
		return false
	for i in arr1:
		if i not in arr2:
			return false
	return true
