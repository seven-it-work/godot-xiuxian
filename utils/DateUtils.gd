extends Node
class_name DateUtils

enum DateUnit{
	YEAR,
	MONTH,
	DAY,
}

# 将天数转换为对应单位的数据
# 例如:
# 天数=365,单位=年,返回1
# 天数=730,单位=年,返回2
static func convert_days(days:int,dateUnit:DateUnit=DateUnit.YEAR)->int:
	if dateUnit==DateUnit.YEAR:
		return ceil(days/365.0)
	return days
