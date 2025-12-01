@tool
extends Control

# 0-indexed day
@export var day: int = 0:
    set(value):
        day = value
        update_ui()

var event_ui_scene: PackedScene = preload("res://game/ui/hud/calendar_ui/calendar_event_ui.tscn")

@onready var today_texture_rect: TextureRect = %TodayTextureRect
@onready var bg_panel_container: PanelContainer = %BgPanelContainer
@onready var day_label: Label = %DayLabel
@onready var event_container: VBoxContainer = %EventContainer

func _ready() -> void:
    call_deferred("update_ui")

func _process(_delta):
    update_today_texture()

func add_event(e: CalendarEvent) -> void:
    if event_container == null:
        return

    var event_ui = event_ui_scene.instantiate()
    event_ui.event = e

    event_container.add_child(event_ui)

func update_today_texture() -> void:
    if today_texture_rect == null:
        return
    
    if Engine.is_editor_hint():
        today_texture_rect.visible = false
        return

    var current_day = TimeManager.get_current_day()
    if day == current_day - 1:
        print_debug("showing aura for: ", day)
        today_texture_rect.visible = true
    else:
        today_texture_rect.visible = false

func update_ui() -> void:
    if day_label == null:
        return
        
    day_label.text = str(day + 1)
    
    if day % 7 in [5, 6]: # Saturday or Sunday
        if bg_panel_container == null:
            return

        var weekend_panel = load("res://game/resources/panels/calendar_header_weekend_panel.tres")
        bg_panel_container.add_theme_stylebox_override("panel", weekend_panel)
        day_label.add_theme_color_override("font_color", Color.WHITE)
