@tool
extends EditorPlugin

func _enter_tree() -> void:
    add_custom_type("InteractionComponent", "Node", preload("res://Addons/Components/InteractionComponent/InteractionComponent.gd"), preload("res://Addons/Components/InteractionComponent/plugin/theme/InteractionComponent.png"))

func _exit_tree() -> void:
    remove_custom_type("InteractionComponent")
