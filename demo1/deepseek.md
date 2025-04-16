# Godot 4 2D 黑暗探索游戏实现指南

下面我将一步步指导你实现这个2D探索游戏，包括角色移动、视野系统和渐变视野效果。

## 1. 项目设置

1. 新建Godot 4项目
2. 选择2D模板
3. 创建以下文件夹结构：
   ```
   /textures
   /scripts
   /scenes
   ```

## 2. 创建基础场景

### 主场景 (Main.tscn)
```
Node2D (根节点)
├── TileMap (地图，可选)
├── Player (角色)
│   ├── Sprite2D (角色圆圈)
│   └── Vision (视野系统)
│       ├── Light2D (主光源)
│       └── LightOccluder2D (遮罩)
└── UI (UI层)
```

## 3. 实现角色移动

创建 `player.gd` 脚本：

```gdscript
extends CharacterBody2D

@export var speed = 300
@export var rotation_speed = 5.0

func _physics_process(delta):
    # 获取输入
    var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    
    # 移动
    velocity = input_dir * speed
    move_and_slide()
    
    # 鼠标看向
    var mouse_pos = get_global_mouse_position()
    var direction = (mouse_pos - global_position).normalized()
    $Vision.rotation = direction.angle()
```

## 4. 实现视野系统

### 创建视野场景 (Vision.tscn)
```
Node2D (Vision)
├── Light2D
└── LightOccluder2D
```

### 视野脚本 (vision.gd)
```gdscript
extends Node2D

@export var max_radius := 500.0
@export var min_radius := 100.0
@export var fov_degrees := 150.0
@export var fade_length := 0.3  # 0-1, 边缘渐暗比例

var current_radius := max_radius

@onready var light := $Light2D

func _ready():
    update_vision()

func update_vision():
    # 设置光照纹理缩放
    light.texture_scale = current_radius / 100.0
    
    # 创建遮罩形状 (扇形)
    var occluder = LightOccluder2D.new()
    var occluder_poly = OccluderPolygon2D.new()
    var poly = create_fov_polygon()
    occluder_poly.polygon = poly
    $LightOccluder2D.occluder = occluder_poly

func create_fov_polygon() -> PackedVector2Array:
    var points = PackedVector2Array()
    var fov = deg_to_rad(fov_degrees)
    var steps = 20
    
    # 中心点
    points.append(Vector2.ZERO)
    
    # 外边缘
    for i in range(steps + 1):
        var angle = -fov/2 + i * (fov/steps)
        points.append(Vector2(cos(angle), sin(angle)) * current_radius
    
    # 内边缘(实现渐变效果)
    for i in range(steps, -1, -1):
        var angle = -fov/2 + i * (fov/steps)
        var inner_radius = current_radius * (1.0 - fade_length)
        points.append(Vector2(cos(angle), sin(angle)) * inner_radius
    
    return points

func set_radius(new_radius: float):
    current_radius = clamp(new_radius, min_radius, max_radius)
    update_vision()

func set_fov(new_fov: float):
    fov_degrees = clamp(new_fov, 10.0, 180.0)
    update_vision()
```

## 5. 创建光照纹理

1. 创建或下载一个圆形渐变纹理 (512x512 PNG)
2. 中心白色，边缘透明
3. 在Light2D中使用这个纹理

## 6. 配置输入映射

在项目设置 > 输入映射中添加：
- move_left (A键)
- move_right (D键)
- move_up (W键)
- move_down (S键)

## 7. 添加环境物体

创建可交互物体场景：
```
StaticBody2D
├── Sprite2D
└── CollisionShape2D
```

## 8. 完善游戏逻辑

### 主游戏脚本 (main.gd)
```gdscript
extends Node2D

@onready var player = $Player

func _ready():
    # 初始化设置
    $Player/Vision.set_radius(300)
    $Player/Vision.set_fov(150)
    
    # 连接信号
    player.connect("item_found", _on_item_found)

func _on_item_found(item):
    print("发现物品: ", item.name)
    # 这里可以添加发现物品后的逻辑
```

## 9. 进阶功能

### 动态调整视野
```gdscript
# 在player.gd中添加
func _input(event):
    if event.is_action_pressed("increase_vision"):
        $Vision.set_radius($Vision.current_radius + 50)
    elif event.is_action_pressed("decrease_vision"):
        $Vision.set_radius($Vision.current_radius - 50)
```

### 视野能量系统
```gdscript
# 在vision.gd中添加
var energy = 100.0
var energy_drain_rate = 1.0

func _process(delta):
    energy = max(energy - energy_drain_rate * delta, 0)
    var radius_ratio = energy / 100.0
    set_radius(max_radius * radius_ratio)
```

## 10. 最终调整

1. 调整光照颜色和强度
2. 添加音效
3. 实现物品收集系统
4. 添加敌人AI（可选）

## 常见问题解决

1. **光照不显示**：
    - 确保Light2D的"Enabled"开启
    - 检查CanvasModulate或其它全屏效果没有覆盖光照
    - 验证纹理是否正确加载

2. **性能问题**：
    - 减少Light2D的数量
    - 使用较简单的遮罩形状
    - 限制动态更新的频率

3. **视野边缘不光滑**：
    - 增加create_fov_polygon()中的steps值
    - 使用更高质量的光照纹理

这个实现提供了完整的黑暗探索游戏基础，你可以根据需要进一步扩展功能，如添加更多物品类型、实现存档系统或增加难度曲线。






# Godot 4 2D黑暗探索游戏 - 小白友好版

我来用最简单的方式帮你实现这个游戏，不需要复杂的代码，我会解释清楚每一步。

## 1. 创建全黑地图

**步骤：**
1. 新建2D场景
2. 添加一个 `ColorRect` 节点
3. 在检查器中：
    - 设置颜色为纯黑（RGB: 0,0,0）
    - 设置锚点为"全屏"（点击布局按钮选择）
    - 确保它在场景树的最底层

这样你的整个游戏画面就是全黑的了。

## 2. 创建玩家角色

**步骤：**
1. 添加一个 `CharacterBody2D` 节点（命名为Player）
2. 添加子节点 `Sprite2D`
    - 导入一个白色圆形图片作为角色
    - 或者使用Godot自带的绘图工具画一个圆
3. 添加 `CollisionShape2D` 并设置圆形碰撞体

## 3. 实现最简单的视野系统（使用图片）

**最简单的方法 - 使用遮罩图片：**

1. 准备一张扇形图片：
    - 白色扇形（150度视角）
    - 边缘有渐变透明效果
    - 背景完全透明
    - [示例图片](https://example.com/vision_mask.png)（你可以自己用绘图软件制作）

2. 在Player节点下添加：
   ```
   Node2D (命名为Vision)
   └── Sprite2D (使用刚才的扇形图片)
   ```

3. 设置Sprite2D：
    - 纹理：你的扇形图片
    - 中心点对齐图片的尖端（这样旋转时会以角色为中心）
    - 混合模式：Add（这样白色部分会照亮环境）

## 4. 让视野跟随鼠标

添加脚本到Player节点：

```gdscript
extends CharacterBody2D

# 移动速度
var speed = 300

func _physics_process(delta):
    # WASD移动
    var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = input * speed
    move_and_slide()
    
    # 让视野朝向鼠标
    var mouse_pos = get_global_mouse_position()
    $Vision.look_at(mouse_pos)
```

## 5. 输入设置

**设置WASD控制：**
1. 菜单：项目 > 项目设置 > 输入映射
2. 添加4个动作：
    - move_left (A键)
    - move_right (D键)
    - move_up (W键)
    - move_down (S键)

## 6. 调整视野大小

要调整视野长度和宽度，最简单的方法是：

1. **调整图片大小**：直接缩放Sprite2D的缩放属性
    - 在检查器中修改 `Scale` 的x和y值

2. **或者**在脚本中添加控制：
```gdscript
# 在_physics_process函数中添加：
if Input.is_action_pressed("zoom_in"):
    $Vision.scale *= 1.02
if Input.is_action_pressed("zoom_out"):
    $Vision.scale *= 0.98
```

然后在输入映射中添加 `zoom_in` (PageUp键) 和 `zoom_out` (PageDown键)

## 7. 添加可交互物品

1. 创建新场景 `Item.tscn`：
   ```
   StaticBody2D
   ├── Sprite2D (物品图片)
   └── CollisionShape2D
   ```

2. 在主场景中放置几个物品实例

## 8. 最终效果

- 全黑地图
- 白色圆形玩家角色
- WASD移动
- 鼠标控制扇形视野方向
- PageUp/PageDown调整视野大小

## 给完全不会编程的小白额外提示

1. **如何创建扇形图片**：
    - 使用免费工具如GIMP或Paint.NET
    - 创建透明背景新图片
    - 用选择工具画一个150度的扇形选区
    - 填充白色，边缘用渐变工具做透明过渡

2. **如果不想写任何代码**：
    - 使用Godot的VisualScript（但Godot 4已弃用）
    - 使用现成的插件如"Fog of War"插件

3. **测试你的游戏**：
    - 按F5测试
    - 确保：
        - 移动正常
        - 视野跟随鼠标
        - 只能看到视野内的物体

这样你应该就能得到一个非常基础的黑暗探索游戏了！如果需要更复杂的效果，可以在这个基础上逐步添加。