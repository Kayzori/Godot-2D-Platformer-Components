extends TweenerArgs
class_name MethodTweenerArgs

@export var mathod_name: StringName
@export var from: VariantValue
@export var to: VariantValue
@export var duration: float
@export var delay: float
@export_enum("In", "Out", "In Out", "Out In") var tween_ease: int = 2
@export_enum("Linear", "Sine", "Quint", "Quart", "Quad", "Expo", "Elastic", "Cubic", "Circ", "Bounce", "Back", "Spring") var tween_trans: int = 0
