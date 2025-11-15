class_name MerchInventory extends Resource

@export var items: Dictionary[MerchResource, int] = {}

func add_merch(merch: MerchResource, amount: int):
    if items.has(merch):
        items[merch] += amount
    else:
        items[merch] = amount

func remove_merch(merch: MerchResource, amount: int):
    if items.has(merch):
        items[merch] -= amount