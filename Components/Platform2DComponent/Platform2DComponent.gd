extends Node
class_name Platform2DComponent

var velocity: Vector2 = Vector2.ZERO
var motion: Vector2 = Vector2.ZERO

var _last_position: Vector2 = Vector2.ZERO
var _is_enabled: bool = false

@export var disabled: bool = false

func _ready() -> void:
    if get_parent() is Node2D:
        _last_position = get_parent().global_position
        if disabled:
            disable()
        else:
            enable()
    else:
        set_physics_process(false)
        set_process(false)

func _process(_delta: float) -> void:
    if disabled and _is_enabled:
        disable()
    elif !disabled and !_is_enabled:
        enable()

func _physics_process(delta: float) -> void:
    if disabled or get_parent() == null or !(get_parent() is Node2D):
        velocity = Vector2.ZERO
        motion = Vector2.ZERO
        return

    var current_pos: Vector2 = get_parent().global_position
    motion = current_pos - _last_position
    velocity = motion / delta
    _last_position = current_pos

func enable() -> void:
    _is_enabled = true
    disabled = false
    _send_interaction_signal(":platform:is_enable")

func disable() -> void:
    _is_enabled = false
    disabled = true
    _send_interaction_signal(":platform:is_disable")

func _send_interaction_signal(suffix: String) -> void:
    if get_parent().has_node("InteractionComponent"):
        var ic: Node = get_parent().get_node("InteractionComponent")
        if ic.has_method("send_interaction_command"):
            ic.send_interaction_command(str(get_parent().get("cmd_id"), suffix))
