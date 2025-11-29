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
var draw_consumption: int = -1

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
                time_to_draw()
            GameState.PlayerTaskType.WATCH_TV:
                good_or_bad_show()

func handle_task_action(task: GameState.PlayerTaskType):
    # Skip if game is on pause
    if GameState.is_paused:
        return

    GameState.is_on_task = false
    GameState.current_task = task

    # Clear existing queues
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

    await GameState.player.navigation_agent.navigation_finished

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
