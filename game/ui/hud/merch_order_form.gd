extends Control

signal window_closed

var total_cost: int = 0:
    set(value):
        total_cost = value
        if total_cost_label != null:
            total_cost_label.text = "%d" % total_cost

@onready var design_inventory_ui: Control = %DesignInventoryUI
@onready var merch_type_menu_button: MenuButton = %MerchTypeMenuButton
@onready var amount_spinbox: SpinBox = %AmountSpinBox
@onready var total_cost_label: Label = %TotalCostLabel

func _ready() -> void:
    visible = false

    if design_inventory_ui.has_signal("design_selected"):
        design_inventory_ui.design_selected.connect(func (_design): update_total_cost())

    amount_spinbox.value_changed.connect(func (_value): update_total_cost())

    # Populate merch type menu
    var merch_type_menu_popup := merch_type_menu_button.get_popup()
    merch_type_menu_popup.id_pressed.connect(_on_menu_item_pressed)
    merch_type_menu_popup.clear(true)
    for k in MerchResource.MerchType.keys():
        if MerchResource.MerchType[k] == MerchResource.MerchType.NONE:
            continue
        merch_type_menu_popup.add_item(k)

    _on_menu_item_pressed(0)  # Set default selection

func open_window() -> void:
    visible = true

func close_window() -> void:
    visible = false
    window_closed.emit()

func update_total_cost() -> void:
    var selected_design = design_inventory_ui.get_selected()
    if selected_design == null:
        total_cost = 0
        return
    
    var merch_type: MerchResource.MerchType = MerchResource.MerchType.NONE
    for k in MerchResource.MerchType.keys():
        if k == merch_type_menu_button.text:
            merch_type = MerchResource.MerchType[k]
            break
    if merch_type == MerchResource.MerchType.NONE:
        total_cost = 0
        return

    var merch = MerchResource.new()
    merch.design = selected_design
    merch.type = merch_type

    var amount := int(amount_spinbox.value)
    var cost_per_unit: int = merch.cost
    total_cost = cost_per_unit * amount

func _on_menu_item_pressed(id: int) -> void:
    var merch_type_menu_popup := merch_type_menu_button.get_popup()
    var selected_text := merch_type_menu_popup.get_item_text(id)
    merch_type_menu_button.text = selected_text
    update_total_cost()

func _on_order_button_pressed() -> void:
    var selected_design = design_inventory_ui.get_selected()
    if selected_design == null:
        print("No design selected")
        return
    
    var merch_type: MerchResource.MerchType = MerchResource.MerchType.NONE
    for k in MerchResource.MerchType.keys():
        if k == merch_type_menu_button.text:
            merch_type = MerchResource.MerchType[k]
            break
    if merch_type == MerchResource.MerchType.NONE:
        print("Invalid merch type selected")
        return

    var amount := int(amount_spinbox.value)
    if amount <= 0:
        print("Amount must be greater than zero")
        return

    var merch = MerchResource.new()
    merch.design = selected_design
    merch.type = merch_type

    total_cost = merch.cost * amount

    if total_cost > GameState.get_money():
        print_debug("Not enough money to order merch")
        return

    StatsManager.spend_money(total_cost)
    MerchManager.order_merch(merch, amount)
    close_window()

func _on_close_button_pressed():
    close_window()

func _on_cancel_button_pressed():
    close_window()
