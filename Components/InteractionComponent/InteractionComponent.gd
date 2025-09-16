extends Node
class_name InteractionComponent

var disable: bool

func send_interaction_command(command: String) -> void:
    for cmd: InteractionCommand in get_parent().interaction_commands as Array[InteractionCommand]:
        if !cmd:
            return
        for sc: String in cmd.signal_command:
            if sc == command:
                for target_node_path: NodePath in cmd.interactable_object:
                    if !target_node_path: break
                    var target_node: Node = get_parent().get_node(target_node_path)
                    if not target_node:
                        continue
                    for ic: String in cmd.interaction_command:
                        ## cmd/change/sc1&&sc2&&sc3.../ic1&&ic2&&ic3.../index
                        if ic.begins_with("cmd/change/"):
                            var parts := ic.split("/")
                            if parts.size() < 5:
                                push_error("Invalid interaction_command format.")
                                continue

                            var idx: int = int(parts[4])

                            var signal_cmd := parts[2]
                            var interaction_cmd := parts[3]

                            if idx < target_node.interaction_commands.size():
                                target_node.interaction_commands[idx].signal_command = signal_cmd.split("&&")
                                target_node.interaction_commands[idx].interaction_command = interaction_cmd.split("&&")
                            else:
                                push_error("Index out of bounds in interaction_commands")

                        elif target_node.has_method("cmd_manager"):
                            target_node.call("cmd_manager", ic)
