extends Node
class_name Character2DUnstickComponent

@export var max_nudge_distance: float = 16.0
@export var nudge_step: float = 1.0
@export var angle_step_degrees: float = 10.0
@export var stuck_trigger_delay: float = 0.05

var stuck_time: float = 0.0

func _physics_process(delta: float) -> void:
    if not (get_parent() is CharacterBody2D):
        return

    var body: CharacterBody2D = get_parent()

    if body.velocity.length() > 0.0 and body.get_last_motion().length() == 0.0:
        stuck_time += delta
    else:
        stuck_time = 0.0

    if stuck_time < stuck_trigger_delay:
        return

    var space_state: PhysicsDirectSpaceState2D = body.get_world_2d().direct_space_state
    var directions: Array[Vector2] = [
        Vector2.UP,
        Vector2.LEFT,
        Vector2.DOWN,
        Vector2.RIGHT
    ]

    var unstuck: bool = false
    var steps: int = int(max_nudge_distance / nudge_step)

    # === 1. Try 4 Cardinal Directions ===
    for dir: Vector2 in directions:
        for i: int in range(1, steps + 1):
            var offset: Vector2 = dir * nudge_step * float(i)
            var test_pos: Vector2 = body.global_position + offset

            var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
            query.position = test_pos
            query.exclude = [body]
            query.collide_with_bodies = true
            query.collide_with_areas = false
            query.collision_mask = body.collision_mask

            var result: Array[Dictionary] = space_state.intersect_point(query, 1)
            if result.is_empty():
                body.global_position = test_pos
                unstuck = true
                break
        if unstuck:
            break

    # === 2. Fallback: Circular Sweep (diagonals, corners, etc) ===
    if not unstuck:
        var shortest_distance: float = INF
        var best_offset: Vector2 = Vector2.ZERO

        for distance: int in range(1, int(max_nudge_distance) + 1, int(nudge_step)):
            for angle_deg: int in range(0, 360, int(angle_step_degrees)):
                var angle_rad: float = deg_to_rad(float(angle_deg))
                var offset: Vector2 = Vector2(cos(angle_rad), sin(angle_rad)) * float(distance)
                var test_pos: Vector2 = body.global_position + offset

                var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
                query.position = test_pos
                query.exclude = [body]
                query.collide_with_bodies = true
                query.collide_with_areas = false
                query.collision_mask = body.collision_mask

                var result: Array[Dictionary] = space_state.intersect_point(query, 1)
                if result.is_empty() and float(distance) < shortest_distance:
                    shortest_distance = float(distance)
                    best_offset = offset
                    unstuck = true

            if unstuck:
                body.global_position += best_offset
                break
