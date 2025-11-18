class_name MerchStackResource extends Resource

@export var merch: MerchResource = null
@export var amount: int = 0: 
    set(value):
        amount = maxi(value, 0) # disallows negative amount
        