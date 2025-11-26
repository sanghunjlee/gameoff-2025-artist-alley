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
}

@export var type: DesignType = DesignType.NONE
@export var sub_type: DesignType = DesignType.NONE

## For future implementation
# var quality: int = 0

## Descriptive Props
@export var icon: Texture = null
@export var title = ""
@export var description = ""

## Time that takes to create the design
## In real time seconds
@export var process_time: float = 5.0

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

    return design

func _to_string():
    return self.title