## Autoload
## Manages Design related logic
extends Node

signal design_started(design: DesignResource)
signal design_completed(design: DesignResource)
signal design_canceled

var design_queue: Array[DesignResource] = []
var current_work: DesignResource = null
var wait_time: float = 0.0

func _process(delta: float) -> void:
    # Skip if paused
    if GameState.is_paused:
        return

    if wait_time > 0.0:
        # If there is a wait, wait
        if GameState.time_state == GameState.TimeControlState.PLAY:
            wait_time -= delta
        elif GameState.time_state == GameState.TimeControlState.FAST:
            wait_time -= delta * TimeManager.fast_forward_multiplier
    else:
        # If there is a current work, complete it
        if current_work != null:
            print('design made:', current_work)
            GameState.design_inventory.add_design(current_work)
            design_completed.emit(current_work)
            StatsManager.consume_inspiration() # might need to change to a signal later
            MessageLogManager.append_log("'" + str(current_work) + "' is complete!")
            current_work = null

        # Check if there is queue and handle it
        if design_queue.size() > 0:
            current_work = design_queue.pop_front()
            print('starting design:', current_work)
            design_started.emit(current_work)
            wait_time = current_work.process_time

func make_design(design: DesignResource):
    print('adding design to queue', design)
    design_queue.append(design)

func make_random_design():
    var d = DesignResource.random()
    make_design(d)

func cancel_work():
    clear_queue()
    if current_work != null:
        current_work = null
        design_canceled.emit()

func clear_queue():
    design_queue.clear()