extends Resource
class_name CustomerResource

enum CustomerType {
    NONE,
    KID,
    FUJOSHI,
    FURRY,
    GOTH,
    GIRLY_GIRL,
    LADY_LOVER,
    CAT_BOY
}

var design_type = DesignResource.DesignType
var merch_type = MerchResource.MerchType

# eg. kid, fujoshi, furry
@export var customer_type_name: String

# eg. yaoi, mecha, cute
@export var liked_design_types: Array[DesignResource.DesignType] = [design_type.NONE]

# eg. charm, sticker
# @export var liked_merch_types: Array[MerchResource.MerchType] = [merch_type.NONE]
@export var sprite_sheet: AtlasTexture