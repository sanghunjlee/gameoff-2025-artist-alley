class_name MerchResource extends Resource

enum MerchType {
    NONE,
    CHARM,
    STICKER,
    POSTER,
}

@export var type: MerchType = MerchType.CHARM
@export var design: DesignResource = null

## For future implementation
# var size: Vector2i = Vector2i.ZERO

@export var icon: Texture = null
@export var description: String = ""

## Time it takes to make this merch
## i.e. Shipping time
@export var process_time: float = 2.0

## Readonly
## Base value of the merch
var base_value: int:
    set = _set_base_value, get = _get_base_value

## Readonly
## Cost of creating the merch
var cost: int:
    set = _set_cost, get = _get_cost


## Getters / Setters
func _set_base_value(_value):
    push_error("Cannot directly set 'base_value' property.")

func _get_base_value():
    match type:
        MerchType.CHARM:
            return 15
        MerchType.STICKER:
            return 5
        MerchType.POSTER:
            return 2


func _set_cost(_value):
    push_error("Cannot directly set 'cost' property.")

func _get_cost():
    match type:
        MerchType.CHARM:
            return 5
        MerchType.STICKER:
            return 2
        MerchType.POSTER:
            return 1


func _to_string() -> String:
    return "<{0}> {1}".format(
        [design.title.to_upper(), MerchType.find_key(type).to_lower()]
    ).strip_edges()
