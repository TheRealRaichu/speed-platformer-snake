extends Control

## KEYBIND
signal back_pressed

var back_button: Button
var keybind_rows: Dictionary = {}

func _ready() -> void:
	_cache_keybind_rows()
	back_button = get_node("BackNode/back")
	back_button.pressed.connect(_on_back_pressed)
	_refresh_keybind_rows()

## Called by main menu script right after this panel is shown.
func focus_back_button() -> void:
	back_button.grab_focus()

## Prepares row references for rebind button wiring and UI updates.
func _cache_keybind_rows() -> void:
	for row_name in Globals.KEYBIND_ROW_ACTIONS.keys():
		var row_path := "PanelContainer/VBoxContainer/%s" % row_name
		var row_node := get_node_or_null(row_path)
		if row_node == null:
			push_warning("Missing keybind row: %s" % row_name)
			continue

		var display_text := row_node.get_node_or_null("DisplayText")
		var input_text := row_node.get_node_or_null("InputText")
		if display_text == null or input_text == null:
			push_warning("Keybind row missing text nodes: %s" % row_name)
			continue

		keybind_rows[row_name] = {
			"action": Globals.KEYBIND_ROW_ACTIONS[row_name],
			"display_text": display_text,
			"input_text": input_text,
		}

## Refreshes each row's action metadata placeholder for next keybind iteration.
func _refresh_keybind_rows() -> void:
	for row_name in keybind_rows.keys():
		var row_data: Dictionary = keybind_rows[row_name]
		var action_name: String = row_data.get("action", "")
		var action_exists := InputMap.has_action(action_name)
		row_data["action_exists"] = action_exists

## Returns the first event for an action for upcoming key display UI.
func get_primary_event_for_action(action_name: String) -> InputEvent:
	if not InputMap.has_action(action_name):
		return null
	var events := InputMap.action_get_events(action_name)
	if events.is_empty():
		return null
	return events[0]

## Placeholder entrypoint for future rebind capture flow.
func begin_rebind_for_row(row_name: String) -> void:
	if not keybind_rows.has(row_name):
		push_warning("Unknown keybind row: %s" % row_name)
		return

func _on_back_pressed() -> void:
	back_pressed.emit()