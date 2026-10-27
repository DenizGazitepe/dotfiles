# superfile theme rendered from the Omarchy theme's colors.toml.
# Omarchy writes it to ~/.local/state/omarchy/current/theme/superfile.toml on
# every `omarchy theme set`; ~/.config/superfile/theme/omarchy.toml links there.

# Unused while code_previewer = "bat", which paints with the terminal palette.
code_syntax_highlight = ""

full_screen_fg = "{{ foreground }}"
full_screen_bg = "{{ background }}"

# Only two colors are supported.
gradient_color = ["{{ blue }}", "{{ magenta }}"]

directory_icon_color = "{{ blue }}"

file_panel_fg = "{{ foreground }}"
file_panel_bg = "{{ background }}"
file_panel_border = "{{ muted }}"
file_panel_border_active = "{{ gradient_start hyprland_active_border accent }}"
file_panel_top_directory_icon = "{{ green }}"
file_panel_top_path = "{{ blue }}"
file_panel_item_selected_fg = "{{ accent }}"
file_panel_item_selected_bg = "{{ selection }}"

footer_fg = "{{ foreground }}"
footer_bg = "{{ background }}"
footer_border = "{{ muted }}"
footer_border_active = "{{ gradient_start hyprland_active_border accent }}"

sidebar_fg = "{{ foreground }}"
sidebar_bg = "{{ background }}"
sidebar_title = "{{ blue }}"
sidebar_border = "{{ background }}"
sidebar_border_active = "{{ gradient_start hyprland_active_border accent }}"
sidebar_item_selected_fg = "{{ accent }}"
sidebar_item_selected_bg = "{{ selection }}"
sidebar_divider = "{{ muted }}"

modal_fg = "{{ foreground }}"
modal_bg = "{{ background }}"
modal_border_active = "{{ gradient_start hyprland_active_border accent }}"
modal_cancel_fg = "{{ background }}"
modal_cancel_bg = "{{ red }}"
modal_confirm_fg = "{{ background }}"
modal_confirm_bg = "{{ green }}"

help_menu_hotkey = "{{ cyan }}"
help_menu_title = "{{ magenta }}"

cursor = "{{ cursor }}"
correct = "{{ green }}"
error = "{{ red }}"
hint = "{{ cyan }}"
cancel = "{{ red }}"
