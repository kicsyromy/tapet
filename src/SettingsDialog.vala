/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class SettingsDialog : Granite.Dialog {
    public SettingsDialog (Gtk.Window parent) {
        transient_for = parent;
        default_width = 400;
        default_height = 300;
    }

    construct {
        /* Download path */
        var path = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            margin = 12,
            vexpand = true
        };
        var path_label = new Gtk.Label (Strings.SETTINGS_DOWNLOAD_FOLDER) {
            margin_right = 100,
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };
        var path_button = new Gtk.Button () {
            halign = Gtk.Align.FILL,
            valign = Gtk.Align.CENTER
        };
        var path_button_label = new Gtk.Label ("C:\\");
        path_button_label.ellipsize = Pango.EllipsizeMode.MIDDLE;
        path_button.child = path_button_label;

        path.pack_start (path_label, false, false);
        path.pack_end (path_button, true, true);

        /* Download options section */
        var download_options = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin = 6,
            vexpand = true
        };
        var download_options_ctx = download_options.get_style_context ();
        download_options_ctx.add_class (Granite.STYLE_CLASS_CARD);
        download_options_ctx.add_class (Granite.STYLE_CLASS_ROUNDED);
        download_options.add (path);

        /* Main layout */
        var layout = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin = 12,
            margin_top = 0
        };
        layout.add (download_options);

        /* Other interface elements */
        ((Gtk.Button)add_button (Strings.MISC_CLOSE, Gtk.ResponseType.OK))
        .get_style_context ()
        .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var content_area = get_content_area ();
        content_area.vexpand = true;
        content_area.pack_start (layout);

        /* Event handlers */
        path_button.clicked.connect (() => {
            var file_chooser = new Gtk.FileChooserNative (Strings.SETTINGS_DOWNLOAD_FOLDER, this, Gtk.FileChooserAction.SELECT_FOLDER, Strings.MISC_OPEN, Strings.MISC_CANCEL);
            var result = file_chooser.run ();
            if (result == Gtk.ResponseType.ACCEPT) {
                path_button_label.set_text (file_chooser.get_file ().get_parse_name ());
            }
        });

        response.connect ((response_id) => {
            destroy ();
        });
    }
}

