extends Node
# manages customer related stuff


# Get random type from customertype enum
func get_random_customer_type() -> CustomerResource.CustomerType:
    return randi_range(0, CustomerResource.CustomerType.keys().size() - 1)
