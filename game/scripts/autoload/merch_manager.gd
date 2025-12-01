## Autoload
## Manages Merch related logic
extends Node

signal merch_started(merch: MerchStackResource)
signal merch_completed(merch: MerchStackResource)
signal merch_canceled

var merch_queue: Array[MerchStackResource] = []
var current_work: MerchStackResource = null
var wait_time: float = 0.0

func _ready():
    if not Engine.has_singleton("DesignMerchManager"):
        Engine.register_singleton("DesignMerchManager", self)


func _process(delta: float) -> void:
    if GameState.is_paused:
        return

    if wait_time > 0.0:
        if GameState.is_paused:
            return

        # If there is a wait, wait
        if GameState.time_state == GameState.TimeControlState.PLAY:
            wait_time -= delta
        elif GameState.time_state == GameState.TimeControlState.FAST:
            wait_time -= delta * TimeManager.fast_forward_multiplier
    else:
        if current_work != null:
            #print("Merch completed: " + str(current_work))
            GameState.merch_inventory.add_merch(current_work.merch, current_work.amount)
            merch_completed.emit(current_work)
            MessageLogManager.append_log("'" + str(current_work) + "' is complete!")
            current_work = null

        # Check if there is queue and handle it
        if merch_queue.size() > 0:
            current_work = merch_queue.pop_front()
            merch_started.emit(current_work)
            wait_time = current_work.process_time

func order_merch(merch: MerchResource, amount: int):
    var stack = MerchStackResource.new(merch, amount)
    merch_queue.append(stack)

func add_merch_to_inventory_with_design_type(design_type: DesignResource.DesignType) -> void:
    var merch = MerchResource.new()
    merch.type = MerchResource.MerchType.values()[randi_range(0, MerchResource.MerchType.size() - 1)]
    var design = DesignResource.new("test_design", design_type)
    merch.design = design
    #MerchManager.order_merch(merch, 100)
    GameState.merch_inventory.add_merch(merch, 1)
    #print_debug("inventory: ", GameState.merch_inventory.stacks)

func remove_random_merch_by_design_types(designs: Array[DesignResource.DesignType], amount: int = 1) -> bool:
    ## Buy random merch from inventory matching design types
    ## If designs is empty, buy any merch
    ## Returns true if purchase was successful, false otherwise
    var available_stacks := GameState.merch_inventory.get_stacks_by_design_types(designs)
    var available_amount: int = GameState.merch_inventory.count_merch_amount_by_design_types(designs)

    if available_stacks.size() == 0:
        return false
    
    if available_amount < amount:
        return false
    
    available_stacks.shuffle()

    var buy_amount: int = amount
    for stack in available_stacks:
        var remaining = GameState.merch_inventory.remove_merch(stack.merch, buy_amount)
        var actual_buy_amount = buy_amount - remaining
        var total_cost = actual_buy_amount * stack.merch.base_value
        StatsManager.add_money(total_cost)
        
        if remaining == 0:
            break

        buy_amount = remaining

    return true

func clear_queue():
    merch_queue.clear()

func cancel_merch(index: int = 0):
    ## Index of merch to cancel
    ## If the index is 0, cancels the current work
    ## If the index is greater than 0, cancels the merch at index - 1 in the queue
    if index < 0 or index > merch_queue.size():
        return
    if index == 0:
        if current_work != null:
            # Refund the money
            StatsManager.add_money(current_work.total_cost)

            current_work = null
            wait_time = 0.0

            merch_canceled.emit()
    else:
        var canceled_item = merch_queue.pop_at(index - 1)
        
        # Refund the money
        StatsManager.add_money(canceled_item.total_cost)

        merch_canceled.emit()
