## Autoload
## Manages Merch related logic
@tool
extends Node

func _ready():
    if not Engine.has_singleton("DesignMerchManager"):
        Engine.register_singleton("DesignMerchManager", self)
