class_name MerchResource extends Resource

enum MerchType {
    STICKER,
    CHARM,
    POSTER,
}

enum MerchGenre {
    FURRY,
    MECHA,
    YAOI,
    YURI,
}

## Descriptive word(s) to prefix the name
@export var qualifier: String = ""
@export var genre: MerchGenre = MerchGenre.FURRY
@export var type: MerchType = MerchType.STICKER
@export var description: String = ""
@export var base_value: int = 0
@export var cost: int = 0
@export var process_time: float = 1.0

## Required skill(s) and level(s) needed
@export var requirement: Dictionary[SkillResource, int] = {}

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

func _to_string() -> String:
    return "{0} {1} {2}".format(
        [qualifier, genre_names[genre], type_names[type]]
    ).strip_edges()
