@tool
extends EditorPlugin


func _enter_tree() -> void:
    add_custom_type("DynamicAnimationPlayerComponent", "Node", preload("res://Addons/Components/DynamicAnimationPlayerComponent/DynamicAnimationPlayerComponent.gd"), preload("res://Addons/Components/DynamicAnimationPlayerComponent/plugin/theme/DynamicAnimationPlayerComponent.png"))


func _exit_tree() -> void:
    remove_custom_type("DynamicAnimationPlayerComponent")
