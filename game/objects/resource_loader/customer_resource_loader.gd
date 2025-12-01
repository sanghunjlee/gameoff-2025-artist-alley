class_name CustomerResourceLoader extends Node

@onready var dict: Dictionary[CustomerResource.CustomerType, CustomerResource] = {
    CustomerResource.CustomerType.KID: load("res://game/resources/customers/kid_customer.tres"),
    CustomerResource.CustomerType.FUJOSHI: load("res://game/resources/customers/fujoshi_customer.tres"),
    CustomerResource.CustomerType.FURRY: load("res://game/resources/customers/furry_customer.tres"),
    CustomerResource.CustomerType.GOTH: load("res://game/resources/customers/goth_customer.tres"),
    CustomerResource.CustomerType.GIRLY_GIRL: load("res://game/resources/customers/girly_girl_customer.tres"),
    CustomerResource.CustomerType.LADY_LOVER: load("res://game/resources/customers/lady_lover_customer.tres")
}

func get_random_customer_type() -> CustomerResource.CustomerType:
    var types = dict.keys()
    return types[randi() % types.size()]

func get_random_customer_data() -> CustomerResource:
    var random_type = get_random_customer_type()
    return dict[random_type]
