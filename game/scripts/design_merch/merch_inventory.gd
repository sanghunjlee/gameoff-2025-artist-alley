class_name MerchInventory extends Resource

signal out_of_stock(index: int)
signal inventory_updated

@export var stacks: Array[MerchStackResource] = []


func find_merch(merch: MerchResource) -> int:
    ## Find the merch in the stacks and return the index
    ## Returns -1 if not found
    for i in range(len(stacks)):
        if stacks[i].merch == merch:
            return i

    return -1

func find_merch_by_design_type(design_type: DesignResource.DesignType) -> int:
    ## Find the merch in the stacks by design type and return the index
    ## Returns -1 if not found
    for i in range(len(stacks)):
        if stacks[i].merch.design.type == design_type:
            return i

    return -1

func has_merch(merch: MerchResource) -> bool:
    return find_merch(merch) != -1

func has_design_type(design_type: DesignResource.DesignType) -> bool:
    return find_merch_by_design_type(design_type) != -1

func count_merch_amount(merch: MerchResource) -> int:
    var index = find_merch(merch)
    return stacks[index].amount if index != -1 else 0

func count_merch_amount_by_design_types(design_types: Array[DesignResource.DesignType]) -> int:
    var amount: int = 0
    for stack in stacks:
        if stack.merch.design.type in design_types or design_types.size() == 0:
            amount += stack.amount
    return amount

func get_stacks_by_design_type(design_type: DesignResource.DesignType) -> Array[MerchStackResource]:
    var result: Array[MerchStackResource] = []
    for stack in stacks:
        if stack.merch.design.type == design_type:
            result.append(stack)
    return result

func get_stacks_by_design_types(design_types: Array[DesignResource.DesignType]) -> Array[MerchStackResource]:
    if design_types.size() == 0:
        return stacks

    var result: Array[MerchStackResource] = []
    for stack in stacks:
        if stack.merch.design.type in design_types:
            result.append(stack)
    return result

func add_merch(merch: MerchResource, amount: int):
    var index = find_merch(merch)
    if index == -1:
        var stack = MerchStackResource.new(merch, amount)
        stacks.append(stack)
        inventory_updated.emit()
        return
    
    stacks[index].amount += amount

func remove_merch(merch: MerchResource, amount: int) -> int:
    ## Removes merch certain amount and returns remaining
    var index = find_merch(merch)
    if index == -1:
        return amount
    
    if stacks[index].amount < amount:
        stacks[index].amount = 0
        inventory_updated.emit()
        return amount - stacks[index].amount
    
    stacks[index].amount -= amount
    
    emit_signal("out_of_stock", index)
    return 0

func clear_inventory():
    stacks.clear()
    inventory_updated.emit()