## Autoload
## Manages Design related logic
extends Node

signal design_started(design: DesignResource)
signal design_completed(design: DesignResource)
signal design_canceled

var design_queue: Array[DesignResource] = []
var current_work: DesignResource = null
var wait_time: float = 0.0
var can_draw: bool = true

func _process(delta: float) -> void:
    # Skip if paused
    if GameState.is_paused:
        return
        
    if !can_draw:
        can_draw = true
        return

    if wait_time > 0.0:

        # If there is a wait, wait
        var adjusted_delta = 0.0
        if GameState.time_state == GameState.TimeControlState.PLAY:
            adjusted_delta = delta
        elif GameState.time_state == GameState.TimeControlState.FAST:
            adjusted_delta = delta * TimeManager.fast_forward_multiplier

        var remaining = 0.0
        if current_work != null:
            if GameState.inspiration_point <= 0.0:
                GameState.is_on_task = false
                cancel_work()
                GameState.player.complain()
                return
            remaining = StatsManager.decrease_inspiration(adjusted_delta)
            
        wait_time -= adjusted_delta - remaining

    else:
        # If there is a current work, complete it
        if current_work != null:
            print('design made:', current_work)
            GameState.design_inventory.add_design(current_work)
            design_completed.emit(current_work)
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
    can_draw = false
    clear_queue()
    if current_work != null:
        current_work = null
        design_canceled.emit()

func clear_queue():
    design_queue.clear()
