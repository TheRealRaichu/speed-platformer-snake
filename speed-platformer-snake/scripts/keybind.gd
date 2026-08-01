extends Control

## KEYBIND
var scene_manager

# Variables
var back_button: Button
var keybind_rows: Dictionary = {}
var pending_rebind_row: String = ""
var selected_row_index := 0

# Back Button 
const BACK_ROW_NAME := "BackNode"
const BACK_ROW_ACTION := "__back__"

# Moving downwards to each keys.
const ROW_ORDER := [
	"Keybind_Up",
	"Keybind_Down",
	"Keybind_Right",
	"Keybind_Left",
	"Keybind_Jump",
	"Keybind_Pause",
	"Keybind_Blink",
	"Keybind_Item",
	"Keybind_Mute",
	"Keybind_DecreaseVolume",
	"Keybind_IncreaseVolume",
	"Keybind_Channel",
	"BackNode",
]

func _ready() -> void:
	_cache_controls()
	_connect_controls()
	_refresh_keybind_rows()
	_setup_initial_state()

## Prepares row references for rebind button wiring and UI updates.
func _cache_controls() -> void:
	back_button = get_node_or_null("PanelContainer/VBoxContainer/BackNode/back")

	for row_name in ROW_ORDER:
		if row_name == BACK_ROW_NAME:
			continue

		var row_path := "PanelContainer/VBoxContainer/%s" % row_name
		var row_node := get_node_or_null(row_path)
		if row_node == null:
			continue

		var display_text := row_node.get_node_or_null("DisplayText")
		var input_text := row_node.get_node_or_null("InputText")
		if display_text == null or input_text == null:
			push_warning("Keybind row missing text nodes: %s" % row_name)
			continue

		keybind_rows[row_name] = {
			"action": Globals.KEYBIND_ROW_ACTIONS.get(row_name, ""),
			"cursor": row_node.get_node_or_null("Cursor"),
			"display_text": display_text,
			"input_text": input_text,
		}

func _connect_controls() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

func _setup_initial_state() -> void:
	for row_name in keybind_rows.keys():
		var row_data: Dictionary = keybind_rows[row_name]
		var row_cursor: Node = row_data.get("cursor", null)
		if row_cursor:
			row_cursor.visible = false

	selected_row_index = 0
	_ensure_valid_selection()
	_apply_selected_row_visuals()

func _ensure_valid_selection() -> void:
	if keybind_rows.is_empty():
		selected_row_index = -1
		return

	var valid_rows := _get_available_rows()
	if valid_rows.is_empty():
		selected_row_index = -1
		return

	selected_row_index = clampi(selected_row_index, 0, valid_rows.size() - 1)

func _get_available_rows() -> Array[String]:
	var rows: Array[String] = []
	for row_name in ROW_ORDER:
		if row_name == BACK_ROW_NAME:
			if back_button:
				rows.append(row_name)
		elif keybind_rows.has(row_name):
			rows.append(row_name)
	return rows

func _get_selected_row_name() -> String:
	var valid_rows := _get_available_rows()
	if selected_row_index < 0 or selected_row_index >= valid_rows.size():
		return ""
	return valid_rows[selected_row_index]

func _apply_selected_row_visuals() -> void:
	for row_name in keybind_rows.keys():
		var row_data: Dictionary = keybind_rows[row_name]
		var row_cursor: Node = row_data.get("cursor", null)
		if row_cursor:
			row_cursor.visible = false

		var display_text: Variant = row_data.get("display_text", null)
		if display_text and display_text.has_method("unfocused"):
			display_text.unfocused()

		var input_text: Variant = row_data.get("input_text", null)
		if input_text and input_text.has_method("unfocused"):
			input_text.unfocused()

	var selected_row_name := _get_selected_row_name()
	if selected_row_name == "":
		return

	if selected_row_name == BACK_ROW_NAME:
		if back_button:
			back_button.grab_focus()
		return

	var selected_data: Dictionary = keybind_rows[selected_row_name]
	var selected_cursor: Node = selected_data.get("cursor", null)
	if selected_cursor:
		selected_cursor.visible = true

	var selected_display: Variant = selected_data.get("display_text", null)
	if selected_display and selected_display.has_method("focused"):
		selected_display.focused()

	var selected_input: Variant = selected_data.get("input_text", null)
	if selected_input and selected_input.has_method("focused"):
		selected_input.focused()

func _move_selection(delta: int) -> void:
	var valid_rows := _get_available_rows()
	if valid_rows.is_empty():
		return

	selected_row_index = posmod(selected_row_index + delta, valid_rows.size())
	_apply_selected_row_visuals()

## Refreshes each row's action metadata placeholder for next keybind iteration.
func _refresh_keybind_rows() -> void:
	for row_name in keybind_rows.keys():
		var row_data: Dictionary = keybind_rows[row_name]
		var action_name: String = row_data.get("action", "")
		var action_exists := action_name != "" and InputMap.has_action(action_name)
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
	if row_name == BACK_ROW_NAME:
		_on_back_pressed()
		return

	if not keybind_rows.has(row_name):
		push_warning("Unknown keybind row: %s" % row_name)
		return

	var row_data: Dictionary = keybind_rows[row_name]
	var action_name: String = row_data.get("action", "")

	if action_name == "":
		# Channel is navigable but intentionally inactive for now.
		return

	pending_rebind_row = row_name

func _try_commit_rebind(event: InputEvent) -> bool:
	if pending_rebind_row == "":
		return false

	if event is InputEventKey:
		var key_event := event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return false
		_commit_rebind_event(key_event)
		return true

	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if not mouse_event.pressed:
			return false
		_commit_rebind_event(mouse_event)
		return true

	if event is InputEventJoypadButton:
		var joy_event := event as InputEventJoypadButton
		if not joy_event.pressed:
			return false
		_commit_rebind_event(joy_event)
		return true

	return false

# Where the Input Key Happens
func _commit_rebind_event(event: InputEvent) -> void:
	if pending_rebind_row == "":
		return

	var row_data: Dictionary = keybind_rows.get(pending_rebind_row, {})
	var action_name: String = row_data.get("action", "")
	if action_name == "":
		pending_rebind_row = ""
		return

	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	pending_rebind_row = ""
	# Update Input Visuals Here

func _unhandled_input(event: InputEvent) -> void:
	if _try_commit_rebind(event):
		get_viewport().set_input_as_handled()
		return

	if pending_rebind_row != "" and event.is_action_pressed("ui_cancel"):
		pending_rebind_row = ""
		_refresh_keybind_rows()
		_apply_selected_row_visuals()
		get_viewport().set_input_as_handled()
		return

	if pending_rebind_row == "":
		if event.is_action_pressed("ui_down"):
			_move_selection(1)
			get_viewport().set_input_as_handled()
			return

		if event.is_action_pressed("ui_up"):
			_move_selection(-1)
			get_viewport().set_input_as_handled()
			return

		if event.is_action_pressed("ui_accept"):
			var selected_row_name := _get_selected_row_name()
			if selected_row_name != "":
				begin_rebind_for_row(selected_row_name)
				get_viewport().set_input_as_handled()
				return

func _on_back_pressed() -> void:
	if scene_manager:
		scene_manager.settings()
