class_name MerchStackResource extends Resource

@export var merch: MerchResource = null
@export var amount: int = 0: 
    set(value):
        amount = maxi(value, 0) # disallows negative amount

## Readonly
var process_time: float:
    set = _set_process_time, get = _get_process_time
        
## Getters / Setters
func _set_process_time(_value):
    push_error("Cannot directly set 'process_time' property.")

func _get_process_time():
    if merch == null: return 0.0
    return merch.process_time * amount


func _init(merch_param: MerchResource, amount_param: int):
    merch = merch_param
    amount = amount_param

func _to_string() -> String:
    return "{0} {1}".format([
        merch,
        amount
    ])