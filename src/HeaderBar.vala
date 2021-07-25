/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class HeaderBar : Hdy.HeaderBar {
    public HeaderBar () {
        Object (
            show_close_button: true,
            has_subtitle: false,
            spacing: 0,
            custom_title: new Granite.HeaderLabel (Strings.APPLICATION_NAME)
            );
    }

    construct {
        get_style_context ().add_class ("default-decoration");

        var browse_button = new Gtk.Button.with_mnemonic (Strings.HEADER_BAR_BROWSE_BUTTON_LABEL) {
            can_focus = false,
            tooltip_text = Strings.HEADER_BAR_BROWSE_BUTTON_TOOLTIP,
            valign = Gtk.Align.CENTER,
            margin_right = 24
        };

        var settings_menuitem = new Gtk.ModelButton ();
        settings_menuitem.text = Strings.MENU_ITEM_SETTINGS;

        var app_menu_grid = new Gtk.Grid () {
            margin_bottom = 3,
            margin_top = 3,
            orientation = Gtk.Orientation.VERTICAL
        };

        app_menu_grid.add (settings_menuitem);
        app_menu_grid.show_all ();

        var app_menu_popover = new Gtk.Popover (null);
        app_menu_popover.add (app_menu_grid);

        var app_menu = new Gtk.MenuButton () {
            can_focus = false,
            image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            popover = app_menu_popover,
            tooltip_text = Strings.HEADER_BAR_MENU_TOOLTIP,
            valign = Gtk.Align.CENTER,
            margin_right = 6
        };

        pack_end (app_menu);
        pack_end (browse_button);

        browse_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("file://%s".printf (TapetApplication.instance.cache_dir), null);
            } catch (Error e)
            {
                TapetApplication.show_warning_dialog (Strings.HEADER_BAR_DIALOG_WARN_OPEN_CACHE_DIR_FAIL, e.message + ".");
            }
        });

        settings_menuitem.clicked.connect (() => {
            (new SettingsDialog (MainWindow.instance)).show_all ();
        });
    }
}
