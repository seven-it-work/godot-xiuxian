# warnings-disable
extends RefCounted

@warning_ignore("unused_variable")
var True = true
@warning_ignore("unused_variable")
var False = false
@warning_ignore("unused_variable")
var None = null


var data = \
{
0:{ "id":0,  "等级":0,  "名称":'基础装备',  "描述":'一些基础数据',  "装备条件":[{'property': 'lv.current', 'value': 0, 'symbol': '>='}],  "生命值":{'min_growth': 0, 'max_growth': 0, 'growth_factor': 0},  "攻击力":{'min_v': 1, 'max_v': 5, 'min_growth': 0, 'max_growth': 5, 'growth_factor': 1},  "防御力":{'min_v': 0, 'max_v': 0, 'min_growth': 0, 'max_growth': 0, 'growth_factor': 0}, },
1:{ "id":1,  "等级":1,  "名称":'小木剑',  "描述":'修仙梦的开始~',  "装备条件":[],  "生命值":{},  "攻击力":{},  "防御力":{}, },
2:{ "id":2,  "等级":1,  "名称":'测试装备',  "描述":'这个装备不可能被装上',  "装备条件":[{'property': 'atk.min_v', 'value': -1, 'symbol': '<'}, {'property': 'lv.current', 'value': -1, 'symbol': '<'}],  "生命值":{},  "攻击力":{},  "防御力":{}, },

}

