extends Node
class_name DynamicAnimationPlayerComponent

var current_animation: String
var active_tween: Tween

signal animation_started(anim_name: StringName)
signal animation_finished(anim_name: StringName)
signal animation_key_changed(anim_name: StringName, key: int)

func _enter_tree() -> void:
    connect("animation_finished", _on_animation_finished)
    connect("animation_key_changed", _on_animation_key_changed)
    connect("animation_started", _on_animation_started)

func _exit_tree() -> void:
    _kill_active_tween()

func _kill_active_tween() -> void:
    if active_tween:
        active_tween.kill()
        active_tween = null

func play_key(key: DynamicAnimationKey) -> void:
    _kill_active_tween()
    if get_tree(): active_tween = get_tree().create_tween()
    
    if !active_tween: return

    for args in key.tweener_args:
        var target_object: Node = get_parent().get_node(args.object) if args.object else get_parent()

        if args is MethodTweenerArgs:
                var method_tween := active_tween.tween_method(
                    Callable(target_object, args.mathod_name),
                    args.from.value,
                    args.to.value,
                    args.duration
                )
                method_tween.set_delay(args.delay)
                method_tween.set_ease(args.tween_ease)
                method_tween.set_trans(args.tween_trans)

        elif args is IntervalTweenerArgs:
                active_tween.parallel().tween_interval(args.time)

        elif args is CallbackTweenerArgs:
                var callback_tween := active_tween.parallel().tween_callback(
                    Callable(target_object, args.callable_name)
                )
                callback_tween.set_delay(args.delay)

        elif args is PropertyTweenerArgs:
                var property_tween := active_tween.parallel().tween_property(
                    target_object,
                    args.property,
                    args.to.value,
                    args.duration
                )
                property_tween.set_delay(args.delay)
                property_tween.set_ease(args.tween_ease)
                property_tween.set_trans(args.tween_trans)
                if args.relative:
                    property_tween.as_relative()
                if not args.from_current:
                    property_tween.from(args.from.value)

    if is_inside_tree():
        await active_tween.finished

    active_tween = null

func play_animation(anim_name: StringName) -> void:
    stop()
    
    if not get_parent().animations.has(anim_name):
        return

    emit_signal("animation_started", anim_name)
    
    current_animation = anim_name
    
    var animation_keys: Array[DynamicAnimationKey] = get_parent().animations.get(anim_name).keys
    for i in range(animation_keys.size()):
        emit_signal("animation_key_changed", anim_name, i)
        await play_key(animation_keys[i])

    emit_signal("animation_finished", anim_name)

func stop() -> void:
    if active_tween:
        active_tween.kill()
        active_tween = null

func get_animations_list() -> Dictionary[StringName, DynamicAnimation]:
    return get_parent().animations

func set_animations_list(animations: Dictionary[StringName, DynamicAnimation]) -> void:
    get_parent().animations = animations.duplicate()

func get_animation(anim_name: StringName) -> DynamicAnimation:
    return get_parent().animations.get(anim_name)

func set_animation(anim_name: StringName, animation: DynamicAnimation) -> void:
    get_parent().animations[anim_name] = animation

func has_animation(anim_name: StringName) -> bool:
    return get_parent().animations.has(anim_name)

func _on_animation_finished(anim_name: StringName) -> void:
    get_parent().emit_signal("animation_finished", anim_name)
    if get_parent().has_node("InteractionComponent"):
        get_parent().get_node("InteractionComponent").send_interaction_command(get_parent().cmd_id + ":animation:finished:" + anim_name)
        get_parent().get_node("InteractionComponent").send_interaction_command(get_parent().cmd_id + ":animation:finished")

func _on_animation_key_changed(anim_name: StringName, key: int) -> void:
    get_parent().emit_signal("animation_key_changed", anim_name, key)
    if get_parent().has_node("InteractionComponent"):
        get_parent().get_node("InteractionComponent").send_interaction_command(get_parent().cmd_id + ":animation:key_changed:" + str(key) + ":" + anim_name)
        get_parent().get_node("InteractionComponent").send_interaction_command(get_parent().cmd_id + ":animation:key_changed:" + str(key))
        get_parent().get_node("InteractionComponent").send_interaction_command(get_parent().cmd_id + ":animation:key_changed")

func _on_animation_started(anim_name: StringName) -> void:
    get_parent().emit_signal("animation_started", anim_name)
    if get_parent().has_node("InteractionComponent"):
        get_parent().get_node("InteractionComponent").send_interaction_command(get_parent().cmd_id + ":animation:started:" + anim_name)
        get_parent().get_node("InteractionComponent").send_interaction_command(get_parent().cmd_id + ":animation:started")
