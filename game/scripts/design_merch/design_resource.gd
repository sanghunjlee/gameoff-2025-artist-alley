class_name DesignResource extends Resource

enum DesignType {
    NONE,
    FURRY,
    MECHA,
    YAOI,
    YURI,
    SHOUJO,
    SHOUNEN,
    CUTE,
    SPICY,
    SPOOKY
}

@export var type: DesignType = DesignType.NONE
@export var sub_type: DesignType = DesignType.NONE

## For future implementation
# var quality: int = 0

## Descriptive Props
@export var title = ""
@export var description = ""

## Time that takes to create the design
## In real time seconds
@export var process_time: float = 10.0

## Readonly
var icon: Texture:
    set = _set_icon, get = _get_icon


## Getters / Setters

func _set_icon(_value):
    push_error("Cannot directly set 'icon' property.")

func _get_icon():
    match type:
        DesignType.FURRY:
            return preload("res://assets/icons/furry-icon.png")
        DesignType.MECHA:
            return preload("res://assets/icons/mecha-icon.png")
        DesignType.YAOI:
            return preload("res://assets/icons/bl-icon.png")
        DesignType.YURI:
            return preload("res://assets/icons/yuri-icon.png")
        DesignType.SHOUJO:
            return preload("res://assets/icons/shoujo-icon.png")
        DesignType.SHOUNEN:
            return preload("res://assets/icons/shounen-icon.png")
        DesignType.CUTE:
            return preload("res://assets/icons/cute-icon.png")
        DesignType.SPICY:
            return preload("res://assets/icons/spicy-icon.png")
        DesignType.SPOOKY:
            return preload("res://assets/icons/spooky-icon.png")
        _:
            return null

## Functions

func _init(title_param: String, type_param: DesignType, sub_type_param: DesignType = DesignType.NONE):
    if type_param == DesignType.NONE:
        print("Should not be None!")
    self.title = title_param
    self.type = type_param
    self.sub_type = sub_type_param


static func random() -> DesignResource:
    var types = DesignType.values()

    # Random range starts from 1 to avoid DesignType.NONE
    var random_type = types[randi_range(1, DesignType.size() - 1)]

    # TODO: Implement randomizing sub type

    # TODO: Better random title generator
    var random_title = "{0} drawing".format([
        str(DesignType.find_key(random_type)).to_pascal_case()
    ])

    var design = DesignResource.new(random_title, random_type)
    design.process_time += randf_range(-2, 2)

    return design

func _to_string():
    return self.title