extends Node
# manages customer related stuff
signal customer_exited

# Get random type from customertype enum
func get_random_customer_type() -> CustomerResource.CustomerType:
    return CustomerResource.CustomerType.keys().pick_random()
