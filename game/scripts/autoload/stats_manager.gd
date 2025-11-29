# Manage player stats such as money and skills
extends Node

# Signal emitted when money is updated
signal money_updated

# Signal emitted when inspiration is updated
signal inspiration_updated

var cooldown: float = 1.0
var wait: float = 0.0
var draw_consumption: int = -1

func _process(delta: float) -> void:
    # cooldown to avoid spamming
    if wait > 0.0:
        wait -= delta
        return
    
    wait = cooldown

    # handle task
    if GameState.is_on_task:
        match GameState.current_task:
            GameState.PlayerTaskType.DRAW:
                time_to_draw()
            GameState.PlayerTaskType.USE_PC:
                if MerchManager.merch_queue.size() < 1:
                    if GameState.design_inventory.designs.size() > 0:
                        var random_index = randi_range(0, GameState.design_inventory.designs.size() - 1)
                        var random_design = GameState.design_inventory.designs[random_index]
                        var random_merch = MerchResource.new()
                        random_merch.type = MerchResource.MerchType.values()[randi_range(0, MerchResource.MerchType.size() - 1)]
                        random_merch.design = random_design
                        var random_amount = randi_range(1, 10)
                        MerchManager.order_merch(random_merch, random_amount)
            GameState.PlayerTaskType.WATCH_TV:
                good_or_bad_show()

func handle_task_action(task: GameState.PlayerTaskType):
    GameState.is_on_task = false
    GameState.current_task = task

    # Clear existing queues
    MerchManager.clear_queue()
    DesignManager.clear_queue()

    # Wait for existing process
    if DesignManager.current_work != null:
        DesignManager.cancel_work()

    # Tell player to do task
    GameState.player.do_task(task)

    # Wait until player is at the task location
    GameState.player.navigation_agent.navigation_finished.connect((func():
        GameState.is_on_task = true
    ), ConnectFlags.CONNECT_ONE_SHOT)

# Increase money by amount
func add_money(amount: int) -> void:
    GameState.money += amount

# Decrease money by amount
func spend_money(amount: int) -> void:
    if GameState.money - amount >= 0:
        GameState.money -= amount

# Change the inspiration points by a certain amount
func change_inspiration(amount: int) -> void:
    if amount < 0 and !can_consume_inspiration(abs(amount)):
        return
    elif GameState.inspiration_point + amount <= 0:
        GameState.inspiration_point = 0
    elif GameState.inspiration_point + amount >= GameState.inspiration_limit:
        GameState.inspiration_point = GameState.inspiration_limit
        MessageLogManager.append_log("'Reached inspiration limit'")
    else:
        GameState.inspiration_point += amount

func can_consume_inspiration(amount: int) -> bool:
    return GameState.inspiration_point >= abs(amount)

# Consume inspiration acoording to the task
func consume_inspiration() -> void:
    match GameState.current_task:
        GameState.PlayerTaskType.DRAW:
            change_inspiration(draw_consumption)  

# Decrease inspiration because the show is too trashy 
func good_or_bad_show() -> void:
    var random_number : int = randi()
    if random_number % 10 == 0:
        GameState.player.complain()
        change_inspiration(-1)
    else:
        change_inspiration(1)

func time_to_draw() -> void:
    if can_consume_inspiration(draw_consumption):
        if DesignManager.design_queue.size() < 5:
            DesignManager.make_random_design()
    else:
        GameState.is_on_task = false
        DesignManager.cancel_work()
        GameState.player.complain()
