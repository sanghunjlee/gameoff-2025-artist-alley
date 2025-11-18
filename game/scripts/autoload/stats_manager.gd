# Manage player stats such as money and skills
extends Node

# Signal emitted when money is updated
signal money_updated

# Signal emitted when inspiration is updated
signal inspiration_updated

var cooldown: float = 1.0
var wait: float = 0.0

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
                DesignManager.make_random_design()
            GameState.PlayerTaskType.USE_PC:
                pass

func handle_task_action(task: GameState.PlayerTaskType):
    GameState.is_on_task = false
    GameState.current_task = task

    # Clear existing queues
    MerchManager.clear_queue()
    DesignManager.clear_queue()

    # Wait for existing process
    if MerchManager.current_work != null:
        await MerchManager.merch_completed
    if DesignManager.current_work != null:
        await DesignManager.design_completed

    # Tell player to do task
    GameState.player.do_task(task)

    # Wait until player is at the task location
    GameState.player.navigation_agent.navigation_finished.connect((func():
        GameState.is_on_task = true
    ), ConnectFlags.CONNECT_ONE_SHOT)