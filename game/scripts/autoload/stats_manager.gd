# Manage player stats such as money and skills
extends Node

signal skip_to_convention
signal player_laid_in_bed
signal player_exited_bed

# Signal emitted when task is changed
signal task_changed

# Signal emitted when money is updated
signal money_updated

# Signal emitted when money is depleted
signal money_depleted

# Signal emitted when inspiration is updated
signal inspiration_updated

var tv_cooldown: float = 1.0
var draw_cooldown: float = 1.0
var wait: float = 0.0
var draw_consumption: int = -1

func _ready() -> void:
    connect("skip_to_convention", _on_skip_to_convention)

func _process(delta: float) -> void:
    if GameState.is_paused:
        return

    if wait > 0.0:
        if GameState.time_state == GameState.TimeControlState.PLAY:
            wait -= delta
        elif GameState.time_state == GameState.TimeControlState.FAST:
            wait -= delta * TimeManager.fast_forward_multiplier
        return

    # handle task
    if GameState.is_on_task:
        match GameState.current_task:
            GameState.PlayerTaskType.DRAW:
                # cooldown between each drawing
                wait = draw_cooldown
                time_to_draw()

            GameState.PlayerTaskType.WATCH_TV:
                # cooldown between each TV sess
                wait = tv_cooldown
                good_or_bad_show()

            GameState.PlayerTaskType.SLEEP:
                emit_signal("player_laid_in_bed")
                GameState.is_on_task = false
                
            _:
                GameState.is_on_task = false

func handle_task_action(task: GameState.PlayerTaskType):
    # Skip if game is on pause
    if GameState.is_paused:
        return
    
    if GameState.current_task == task:
        return

    if GameState.current_task == GameState.PlayerTaskType.SLEEP:
        emit_signal("player_exited_bed")

    GameState.is_on_task = false
    GameState.current_task = task

    # Clear existing queues
    DesignManager.clear_queue()

    # Wait for existing process
    if DesignManager.current_work != null:
        DesignManager.cancel_work()

    # Tell player to do task
    if GameState.player:
        var did_do_task = GameState.player.do_task(task)

        # Wait until player is at the task location
        if did_do_task:
            GameState.player.navigation_agent.navigation_finished.connect((func():
                wait=0.0
                GameState.is_on_task=true
            ), ConnectFlags.CONNECT_ONE_SHOT)

            await GameState.player.navigation_agent.navigation_finished

    # Emit signal so that ui can update
    task_changed.emit()

    
# Increase money by amount
func add_money(amount: int) -> void:
    GameState.money += amount

# Decrease money by amount
func spend_money(amount: int) -> void:
    if GameState.money - amount >= 0:
        GameState.money -= amount

func level_up_inspiration() -> void:
    GameState.inspiration_level += 1
    GameState.inspiration_limit = roundf(100 * exp(0.5 * GameState.inspiration_level))
    MessageLogManager.append_log("'Inspiration limit increased to " + str(GameState.inspiration_limit) + "'")

func increase_inspiration(delta: float) -> void:
    if GameState.inspiration_point < GameState.inspiration_limit:
        GameState.inspiration_point += delta
        # MessageLogManager.append_log("'Current Inspiration: " + str(GameState.inspiration_point) + "'")
    else:
        # MessageLogManager.append_log("'Reached inspiration limit'")
        pass

func decrease_inspiration(delta: float) -> float:
    if GameState.inspiration_point > delta:
        GameState.inspiration_point -= delta
        return 0.0
    else:
        var remaining = delta - GameState.inspiration_point
        GameState.inspiration_point = 0.0
        return remaining


# Decrease inspiration because the show is too trashy 
func good_or_bad_show() -> void:
    var inspiration_change: float = 1.0
    if randi() % 10 == 0:
        GameState.player.complain()
        decrease_inspiration(abs(inspiration_change))
    else:
        increase_inspiration(abs(inspiration_change))

func time_to_draw() -> void:
    if DesignManager.design_queue.size() < 5:
        DesignManager.make_random_design()
    # else:
    #     GameState.is_on_task = false
    #     DesignManager.cancel_work()
    #     GameState.player.complain()

func reset_stats() -> void:
    GameState.money = GameState.INITIAL_MONEY
    GameState.inspiration_point = GameState.INITIAL_INSPIRATION_POINT
    GameState.inspiration_level = GameState.INITIAL_INSPIRATION_LEVEL
    GameState.time_count = GameState.INITIAL_TIME_COUNT
    MerchManager.clear_queue()
    MerchManager.cancel_merch()
    DesignManager.cancel_work()
    GameState.design_inventory.clear_inventory()
    GameState.merch_inventory.clear_inventory()
    MessageLogManager.clear_logs()
    
func _on_skip_to_convention() -> void:
    # Skip to the next convention, change float value later if needed
    # Skip to the rent day if the next convention is after 
    GameState.is_on_task = false
    var current_day = TimeManager.get_current_day()
    var days_until_rent_due = GameState.RENT_DUE_DAY - current_day
    var days_until_next_con = TimeManager.get_days_until_next_convention()
    if days_until_rent_due < days_until_next_con:
        TimeManager.pass_day(days_until_rent_due, 0.0)
    else:
        TimeManager.pass_day(days_until_next_con, 0.0)
