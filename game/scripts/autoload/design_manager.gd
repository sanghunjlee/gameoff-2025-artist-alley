## Autoload
## Manages Design related logic
extends Node

signal design_started(design: DesignResource)
signal design_completed(design: DesignResource)

var design_queue: Array[DesignResource] = []
var current_work: DesignResource = null
var wait_time: float = 0.0

func _process(delta: float) -> void:
    if wait_time > 0.0:
        # If there is a wait, wait
        wait_time -= delta
    else:
        # If there is a current work, complete it
        if current_work != null:
            design_completed.emit(current_work)
            GameState.design_inventory.add_design(current_work)
            current_work = null

        # Check if there is queue and handle it
        if design_queue.size() > 0:
            current_work = design_queue.pop_front()
            design_started.emit(current_work)
            wait_time = current_work.process_time

func make_design(design: DesignResource):
    design_queue.append(design)

func make_random_design():
    var d = DesignResource.random()
    make_design(d)
