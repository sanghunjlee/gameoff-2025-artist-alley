class_name MerchStackResource extends Resource

@export var merch: MerchResource = null
@export var amount: int = 0: 
    set(value):
        amount = maxi(value, 0) # disallows negative amount
        
func _init(merch_param: MerchResource, amount_param: int):
    merch = merch_param
    amount = amount_param