class_name DesignInventory extends Resource

signal inventory_updated

@export var designs: Array[DesignResource] = []

func find_design(design: DesignResource) -> int:
    ## Find the design in the designs and return the index
    ## Returns -1 if not found
    for i in range(len(designs)):
        if designs[i] == design:
            return i
    return -1

func has_design(design: DesignResource) -> bool:
    return find_design(design) != -1

func add_design(design: DesignResource):
    var index = find_design(design)
    if index == -1:
        designs.append(design)
        inventory_updated.emit()

func remove_design(design: DesignResource):
    ## Removes design certain amount and returns remaining
    var index = find_design(design)
    if index != -1:
        designs.remove_at(index)
        inventory_updated.emit()
