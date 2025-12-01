class_name MerchOrderResource extends Resource

var order: MerchStackResource

var created_time: float = 0.0
var start_time: float = 0.0
var progress: float = 0.0


## Readonly
var finish_time: float:
    get = _get_finish_time, set = _set_finish_time


# Getters / Setters

func  _get_finish_time():
    return start_time + order.process_time

func _set_finish_time(_value):
    push_error("Cannot directly set 'finish_time' property!")


func _init(o: MerchStackResource):
    self.order = o
    self.created_time = GameState.time_count

func start_order():
    self.start_time = GameState.time_count
