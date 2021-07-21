/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class SettingsDialog : Granite.Dialog {
    public SettingsDialog (Gtk.Window parent) {
        transient_for = parent;
    }

    construct {
        var section_general_settings = create_settings_section (Strings.SETTINGS_LABEL_SECTION_GENERAL_SETTINGS);

        var background_change_interval = create_settings_item (Strings.SETTINGS_LABEL_ITEM_BACKGROUND_CHANGE_INTERVAL, new Gtk.ComboBox ());
        section_general_settings.add (background_change_interval);

        var startup_set_latest = create_settings_item (Strings.SETTINGS_LABEL_ITEM_STARTUP_SET_LATEST, new Gtk.Switch ());
        section_general_settings.add (startup_set_latest);

        var dont_reuse_wallpapers = create_settings_item (Strings.SETTINGS_LABEL_ITEM_DONT_REUSE_OLD_WALLPAPERS, new Gtk.Switch ());
        section_general_settings.add (dont_reuse_wallpapers);

        var refresh_images = create_settings_item (Strings.SETTINGS_LABEL_ITEM_REFRESH_IMAGE_LIST, new Gtk.ComboBox ());
        section_general_settings.add (refresh_images);

        var notifications = create_settings_item (Strings.SETTINGS_LABEL_ITEM_ENABLE_NOTIFICATIONS, new Gtk.Switch ());
        section_general_settings.add (notifications);

        var section_application_settings = create_settings_section (Strings.SETTINGS_LABEL_SECTION_APPLICATION_SETTINGS);

        var keep_running = create_settings_item (Strings.SETTINGS_LABEL_ITEM_KEEP_RUNNING_WHEN_CLOSED, new Gtk.Switch ());
        section_application_settings.add (keep_running);

        var layout = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin = 12,
            margin_top = 0
        };
        layout.add (section_general_settings);
        layout.add (section_application_settings);

        (add_button (Strings.MISC_CLOSE, Gtk.ResponseType.OK))
            .get_style_context ()
            .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var content_area = get_content_area ();
        content_area.vexpand = true;
        content_area.pack_start (layout);

        //  path_button.clicked.connect (() => {
        //      var file_chooser = new Gtk.FileChooserNative (Strings.SETTINGS_DOWNLOAD_FOLDER, this, Gtk.FileChooserAction.SELECT_FOLDER, Strings.MISC_OPEN, Strings.MISC_CANCEL);
        //      var result = file_chooser.run ();
        //      if (result == Gtk.ResponseType.ACCEPT) {
        //          path_button_label.set_text (file_chooser.get_file ().get_parse_name ());
        //      }
        //  });

        response.connect ((response_id) => {
            destroy ();
        });
    }

    private static Gtk.Box create_settings_section (string section_name) {
        var section = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin = 6,
            vexpand = true
        };
        var section_context = section.get_style_context ();
        section_context.add_class (Granite.STYLE_CLASS_CARD);
        section_context.add_class (Granite.STYLE_CLASS_ROUNDED);

        var label = new Gtk.Label (section_name) {
            halign = Gtk.Align.START,
            margin = 6,
            margin_left = 12,
            margin_bottom = 0
        };

        label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
        section.add (label);

        return section;
    }

    private static Gtk.Box create_settings_item (string label_text, Gtk.Widget ? widget = null, out Gtk.Widget ? the_widget = null) {
        var container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            margin_top = 0,
            margin_bottom = 12,
            margin_left = 24,
            margin_right = 24,
            vexpand = true
        };

        var label = new Gtk.Label (label_text) {
            margin_right = 32,
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };

        container.pack_start (label, false, false);

        if (widget != null) {
            widget.halign = Gtk.Align.END;
            widget.valign = Gtk.Align.CENTER;
            container.pack_end (widget, false, false);

            the_widget = widget;
        } else {
            the_widget =null;
        }

        return container;
    }
}

