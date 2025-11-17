@tool
class_name MerchResource extends Resource

enum MerchType {
    STICKER,
    CHARM,
    POSTER,
}

enum MerchGenre {
    NONE = 0,
    FURRY = 1,
    MECHA = 2,
    YAOI = 4,
    YURI = 8,
}

## Descriptive word(s) to prefix the name
@export var icon: Texture = null
@export var qualifier: String = ""
@export_flags("Furry", "Mecha", "Yaoi", "Yuri") var genre: int = 0
@export var type: StringName = MerchConstants.MERCH_TYPE_CHARM:
    set(value):
        type = value
        update_color()
@export var description: String = ""
@export var base_value: int = 0
@export var cost: int = 0
@export var process_time: float = 1.0

## Required skill(s) and level(s) needed
@export var requirement: Dictionary[SkillResource, int] = {}

var color: Color = Color.WHITE

var type_names = {
    MerchType.STICKER: "Sticker",
    MerchType.CHARM: "Charm",
    MerchType.POSTER: "Poster"
}

var genre_names = {
    MerchGenre.FURRY: "Furry",
    MerchGenre.MECHA: "Mecha",
    MerchGenre.YAOI: "Yaoi",
    MerchGenre.YURI: "Yuri"
}

func update_color():
    var color_map = {
        MerchConstants.MERCH_TYPE_CHARM: Color.RED,
        MerchConstants.MERCH_TYPE_POSTER: Color.BLUE,
    }
    if type in color_map:
        color = color_map[type]
    else:
        color = Color.WHITE


func _to_string() -> String:
    return "{0} {1} {2}".format(
        [qualifier, genre_names[genre], type]
    ).strip_edges()
