extends Node2D
# Display MerchStacks in the player's inventory

@export var row_size: int = 3
@export var cell_width: int = 16
@export var merch_cell: MerchDisplayCell

@onready var cells: Array[MerchDisplayCell] = []

func _ready() -> void:
    initialize_display(GameState.merch_inventory.stacks.size())

# initialize cells in a grid starting from bottom-left and building right and up.
# second cell in bottom row should be skipped as the player is expected to stand there.
# e.g. for 7 MerchStacks with row_size 3:
# xx
# xxx
# x x
func initialize_display(merch_stacks_size: int) -> void:
    for i in merch_stacks_size: # +1 to account for skipped cell
        # copy the cell scene and make it visible
        var cell = merch_cell.duplicate()
        cell.visible = true

        # position in grid
        cell.position = _get_grid_position(i)

        # set cell to its corresponding merch stack from inventory
        var merch_stack = _get_next_merch_stack(i)
        cell.merch_stack = merch_stack
        cell.merch_sprite.texture = merch_stack.merch.design.icon
        cell.update_display()
        
        # add to scene and track
        add_child(cell)
        cells.append(cell)

# second cell placed in bottom row skips forward a position
# if more than 2 stacks in inventory, ensure 3rd cell and onward are placed after the 2nd cell
# for example, with row_size 3 and 7 stacks, the positions would be:
# bottom row: 0, (skip), 1
# middle row: 2, 3, 4
# top row:    5, 6
func _get_grid_position(i) -> Vector2:
    if i == 0:
        return merch_cell.position
    elif i > 0: # account for skipped cell
        i += 1
    var row = int(i / row_size)
    var col = i % row_size
    return merch_cell.position + Vector2(col * cell_width, -row * cell_width)

func _get_next_merch_stack(index: int) -> MerchStackResource:
    if index >= GameState.merch_inventory.stacks.size():
        return null
    return GameState.merch_inventory.stacks[index]
