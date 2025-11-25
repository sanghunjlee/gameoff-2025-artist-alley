class_name CustomerResourceLoader extends Node

@export var dict: Dictionary[CustomerResource.CustomerType, CustomerResource] = {}

func get_random_customer_type() -> CustomerResource.CustomerType:
    var types = dict.keys()
    return types[randi() % types.size()]

func get_random_customer_data() -> CustomerResource:
    var random_type = get_random_customer_type()
    return dict[random_type]
