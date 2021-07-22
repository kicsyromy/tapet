/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class MainWindow : Hdy.ApplicationWindow {
    internal static MainWindow instance = null;

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
        default_width = 1036;
        default_height = 800;
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);

        box.add (new HeaderBar ());
        box.add (new Content ());

        add (box);
        show_all ();
    }
}
