class_name MerchInventory extends Resource

@export var stacks: Array[MerchStackResource] = []

func find_merch(merch: MerchResource) -> int:
    ## Find the merch in the stacks and return the index
    ## Returns -1 if not found
    for i in range(len(stacks)):
        if stacks[i].merch == merch:
            return i

    return -1

func has_merch(merch: MerchResource) -> bool:
    return find_merch(merch) != -1

func count_merch_amount(merch: MerchResource) -> int:
    var index = find_merch(merch)
    return stacks[index].amount if index != -1 else 0

func add_merch(merch: MerchResource, amount: int):
    var index = find_merch(merch)
    if index == -1:
        var stack = MerchStackResource.new(merch, amount)
        stacks.append(stack)
        return 
    
    stacks[index].amount += amount

func remove_merch(merch: MerchResource, amount: int) -> int:
    ## Removes merch certain amount and returns remaining
    var index = find_merch(merch)
    if index == -1:
        return amount
    
    if stacks[index].amount < amount:
        stacks[index].amount = 0
        return amount - stacks[index].amount
    
    stacks[index].amount -= amount
    return 0