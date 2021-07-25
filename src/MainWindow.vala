/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class MainWindow : Hdy.ApplicationWindow {
    internal static MainWindow instance = null;

    private uint _configure_id;

    private Content _content;

    public MainWindow () {
        delete_event.connect (() => {
            var application_settings = TapetApplication.instance.application_settings;
            var setting_changed_by_user = (application_settings.get_user_value (Strings.APPLICATION_SETTINGS_KEEP_RUNNING_WHEN_CLOSED) != null);
            if (!setting_changed_by_user) {
                var response = TapetApplication.show_question_dialog (Strings.CONTENT_DIALOG_KEEP_RUNNING_PRIMARY, Strings.CONTENT_DIALOG_KEEP_RUNNING_DESCRIPTION, Strings.MISC_YES, Strings.MISC_NO);
                application_settings.set_boolean (Strings.APPLICATION_SETTINGS_KEEP_RUNNING_WHEN_CLOSED, response);
            }

            set_visible (false);

            return application_settings.get_boolean (Strings.APPLICATION_SETTINGS_KEEP_RUNNING_WHEN_CLOSED);
        });
        instance = this;
    }

    construct {
        var application_settings = TapetApplication.instance.application_settings;

        var rect = Gtk.Allocation ();
        application_settings.get ("window-size", "(ii)", out rect.width, out rect.height);
        set_allocation (rect);

        int window_x, window_y;
        application_settings.get ("window-position", "(ii)", out window_x, out window_y);
        if (window_x != -1 && window_y != -1) {
            move (window_x, window_y);
        }

        if (application_settings.get_boolean ("window-maximized")) {
            maximize ();
        }

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);

        _content = new Content ();

        box.add (new HeaderBar ());
        box.add (_content);

        add (box);
    }

    public void refresh_content_from_provider (ImageProvider image_provider) {
        _content.refresh_content_from_provider (image_provider);
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        if (_configure_id != 0) {
            GLib.Source.remove (_configure_id);
        }

        _configure_id = Timeout.add (100, () => {
            _configure_id = 0;
            var application_settings = TapetApplication.instance.application_settings;

            if (is_maximized) {
                application_settings.set_boolean ("window-maximized", true);
            } else {
                application_settings.set_boolean ("window-maximized", false);

                Gdk.Rectangle rect;
                get_allocation (out rect);
                application_settings.set ("window-size", "(ii)", rect.width, rect.height);

                int root_x, root_y;
                get_position (out root_x, out root_y);
                application_settings.set ("window-position", "(ii)", root_x, root_y);
            }

            return false;
        });

        return base.configure_event (event);
    }
}
