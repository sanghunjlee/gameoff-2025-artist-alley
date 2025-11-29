# Manage player stats such as money and skills
extends Node

# Signal emitted when task is changed
signal task_changed

# Signal emitted when money is updated
signal money_updated

# Signal emitted when inspiration is updated
signal inspiration_updated

var cooldown: float = 1.0
var wait: float = 0.0

func _process(delta: float) -> void:
    if GameState.time_state == GameState.TimeControlState.PAUSE:
        return

    # cooldown to avoid spamming
    if wait > 0.0:
        wait -= delta
        return
    
    wait = cooldown

    # handle task
    if GameState.is_on_task:
        match GameState.current_task:
            GameState.PlayerTaskType.DRAW:
                if DesignManager.design_queue.size() < 5:
                    DesignManager.make_random_design()
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
                increase_inspiration()

func handle_task_action(task: GameState.PlayerTaskType):
    # Skip if game is on pause
    if GameState.is_paused:
        return

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

    # Emit signal so that ui can update
    task_changed.emit()

func level_up_inspiration() -> void:
    GameState.inspiration_level += 1
    GameState.inspiration_limit = int(100 * exp(0.5 * GameState.inspiration_level))
    MessageLogManager.append_log("'Inspiration limit increased to " + str(GameState.inspiration_limit) + "'")

func increase_inspiration() -> void:
    if GameState.inspiration_point < GameState.inspiration_limit:
        GameState.inspiration_point += 1
        MessageLogManager.append_log("'Current Inspiration: " + str(GameState.inspiration_point) + "'")
    else:
        MessageLogManager.append_log("'Reached inspiration limit'")
        return

# Consume inspiration when making merch
func consume_inspiration() -> void:
    match GameState.current_task:
        GameState.PlayerTaskType.DRAW:
            if GameState.inspiration_point <= 0:
                GameState.player.complain()
                return
            elif GameState.inspiration_point <= 2:
                GameState.inspiration_point = 0
            else:
                GameState.inspiration_point -= 2
