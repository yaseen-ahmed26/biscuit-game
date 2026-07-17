extends Node

signal display_code(code: String)
signal change_screen(old_screen, new_screen)
signal stats_changed(new_stats: Dictionary)
signal data_loaded(save_data: Dictionary)
signal data_saved()
signal show_message_popup(info_name: String, details: Array)
signal show_message_proceed()
