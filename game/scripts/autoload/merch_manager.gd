## Autoload
## Manages Merch related logic
#@tool
extends Node

signal merch_started(merch: MerchStackResource)
signal merch_completed(merch: MerchStackResource)

var merch_queue: Array[MerchStackResource] = []
var current_work: MerchStackResource = null
var wait_time: float = 0.0
var merch_cost: int = 5

func _ready():
    if not Engine.has_singleton("DesignMerchManager"):
        Engine.register_singleton("DesignMerchManager", self)


func _process(delta: float) -> void:
    if GameState.is_paused:
        return

    if not can_make_merch():
        return

    if wait_time > 0.0:
        # If there is a wait, wait
        wait_time -= delta
    else:
        if current_work != null:
            GameState.merch_inventory.add_merch(current_work.merch, current_work.amount)
            merch_completed.emit(current_work)
            MessageLogManager.append_log("'" + str(current_work) + "' is complete!")
            StatsManager.spend_money(merch_cost)
            current_work = null

        # Check if there is queue and handle it
        if can_make_merch() and merch_queue.size() > 0:
            current_work = merch_queue.pop_front()
            merch_started.emit(current_work)
            wait_time = current_work.process_time
        else:
            # Not enough money to make merch, complain
            if not can_make_merch():
                GameState.player.complain()

func order_merch(merch: MerchResource, amount: int):
    var stack = MerchStackResource.new(merch, amount)
    merch_queue.append(stack)

func buy_random_merch_by_design_types(designs: Array[DesignResource.DesignType], amount: int = 1) -> bool:
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
        
        if remaining == 0:
            break

        buy_amount = remaining

    return true


func clear_queue():
    merch_queue.clear()

func can_make_merch() -> bool:
    return GameState.get_money() - merch_cost >= 0