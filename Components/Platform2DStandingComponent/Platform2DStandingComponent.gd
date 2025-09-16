extends ShapeCast2D
class_name Platform2DStandingComponent

var platform_velocity: Vector2 = Vector2.ZERO
var platform_motion: Vector2 = Vector2.ZERO
var current_platform: Node2D = null

func _process(_delta: float) -> void:
    global_rotation = 0.0

func _physics_process(_delta: float) -> void:
    platform_velocity = get_platform_velocity()
    platform_motion = get_platform_motion()
    if is_on_platform():
        get_parent().global_position += platform_motion
        

func get_platform_velocity() -> Vector2:
    if current_platform and current_platform.has_node("Platform2DComponent"):
        return current_platform.platform.velocity
    return Vector2.ZERO

func get_platform_motion() -> Vector2:
    if current_platform and current_platform.has_node("Platform2DComponent"):
        return current_platform.platform.motion
    return Vector2.ZERO

func is_on_platform() -> bool:
    if is_colliding():
        for i in get_collision_count():
            if get_collider(i) and get_collider(i).has_node("Platform2DComponent"):
                current_platform = get_collider(i)
                return true
        return (current_platform != null)
    return false
