extends Control

@export var design_inventory_ui: Control
@export var merch_inventory_ui: Control

var design_inventory: DesignInventory
var merch_inventory: MerchInventory

func _ready():
    design_inventory = DesignInventory.new()
    design_inventory_ui.inventory = design_inventory

    merch_inventory = MerchInventory.new()
    merch_inventory_ui.inventory = merch_inventory

func _on_design_button_pressed():
    var design = DesignResource.random()
    design_inventory.add_design(design)


func _on_merch_button_pressed():
    var design = DesignResource.random()
    var merch = MerchResource.new()
    merch.design = design
    merch.type = MerchResource.MerchType.CHARM

    merch_inventory.add_merch(merch, randi_range(1, 10))
