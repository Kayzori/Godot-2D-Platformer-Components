extends Node
class_name Character2DPushingComponent

@export var push_force: float = 100
var is_pushing: bool = false
var impulse := Vector2.ZERO

var timer: Timer = Timer.new()
var timer_started: bool = false

func _ready() -> void:
    timer.one_shot = true
    timer.wait_time = 0.5
    timer.timeout.connect(cooldown)
    add_child(timer)

func _physics_process(_delta: float) -> void:
    if (get_parent() is not CharacterBody2D):
        return
    var body: CharacterBody2D = get_parent()
    if is_pushing and !timer_started:
        timer.start()
        timer_started = true
    for i in range(body.get_slide_collision_count()):
        var slide_collision: KinematicCollision2D = body.get_slide_collision(i)
        var collider := slide_collision.get_collider()
        if collider is RigidBody2D:
            impulse = -slide_collision.get_normal() * push_force
            impulse.x = sign(impulse.x) * clamp(abs(impulse.x), 0, push_force)
            impulse.y = sign(impulse.y) * clamp(abs(impulse.y), 0, push_force)
            collider.apply_central_impulse(round(impulse))
            is_pushing= true

func cooldown() -> void:
    is_pushing = false
    timer_started = false
