extends Node2D

var test_messages = [
    ["You gained 2 inspirations.", MLConstants.LogType.Normal],
    ["You gained 4 inspirations.", MLConstants.LogType.Normal],
    ["You gained 5 inspirations.", MLConstants.LogType.Normal],
    ["You lost 3 inspirations..", MLConstants.LogType.Normal],
    ["You created a 'Furry' charm.", MLConstants.LogType.Normal],
    ["You created a 'Yaoi' sticker.", MLConstants.LogType.Normal],
    ["AX Convention is starting!", MLConstants.LogType.Important],
    ["AX Convention is ending soon!", MLConstants.LogType.Important],
]
var is_con_started = false

func get_random_test_index() -> int:
    var i = randi_range(0, test_messages.size() - 1)

    if is_con_started and i == 6:
        return get_random_test_index()
    if not is_con_started and i == 7:
        return get_random_test_index()

    return i

func _on_button_pressed():
    var index = get_random_test_index()
    if index == 6:
        is_con_started = true
    if index == 7:
        is_con_started = false
    var test = test_messages[index]
    Engine.get_singleton("MessageLogManager").append_log(test[0], test[1])