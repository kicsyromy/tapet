/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

public class TapetApplication : Gtk.Application {
    internal static TapetApplication instance = null;

    internal SystemSettings system_settings = new SystemSettings ();
    internal Settings application_settings = new Settings (Strings.APPLICATION_ID);
    internal GenericArray<ImageProvider> image_providers = new GenericArray<ImageProvider>();
    internal string cache_dir;
    internal string config_dir;
    internal string background_history_file;

    private MainWindow _main_window = null;
    private ImageRefreshHandler _image_refresh_handler = null;
    private BackgroundChangeHandler _background_change_handler = null;

    public TapetApplication () {
        Object (
            application_id: Strings.APPLICATION_ID,
            flags : ApplicationFlags.FLAGS_NONE
            );

        startup.connect (() => {
            Hdy.init ();
        });
    }

    public static void show_fatal_dialog (string primary_text, string secondary_text) {
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            primary_text, secondary_text,
            "dialog-error",
            Gtk.ButtonsType.NONE
            );

        message_dialog.add_button (Strings.MISC_QUIT, Gtk.ResponseType.OK)
            .get_style_context ()
            .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        message_dialog.run ();
        message_dialog.destroy ();

        instance.quit ();
    }

    public static void show_warning_dialog (string primary_text, string secondary_text) {
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            primary_text, secondary_text,
            "dialog-warning",
            Gtk.ButtonsType.NONE
            );

        message_dialog.add_button (Strings.MISC_CLOSE, Gtk.ResponseType.OK)
            .get_style_context ()
            .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        message_dialog.run ();
        message_dialog.destroy ();
    }

    public static bool show_question_dialog (string primary_text, string secondary_text, string accept_text, string reject_text) {
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            primary_text, secondary_text,
            "dialog-question",
            Gtk.ButtonsType.NONE
            );

        message_dialog.add_button (reject_text, Gtk.ResponseType.REJECT);
        message_dialog.add_button (accept_text, Gtk.ResponseType.ACCEPT)
            .get_style_context ()
            .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        bool response = message_dialog.run () == Gtk.ResponseType.ACCEPT;
        message_dialog.destroy ();

        return response;
    }

    protected override void activate () {
        if (_main_window != null) {
            _main_window.set_visible (true);
        } else {
            try {
                cache_dir = Environment.get_home_dir () + "/.cache/" + Strings.APPLICATION_ID;
                File.new_for_path (cache_dir).make_directory ();
            } catch (Error error) {
                if (error.code != IOError.EXISTS) {
                    critical ("%s: %d: %s\n", Strings.APPLICATION_ERROR_CACHE_CREATE, error.code, error.message);
                    string error_cache_create_msg = Strings.APPLICATION_ERROR_CACHE_CREATE;
                    show_fatal_dialog (Strings.APPLICATION_ERROR_INIT_FAILED, error_cache_create_msg + ".\n\n" + error.message + ".");
                }
            }

            try {
                config_dir ="%s/%s".printf (Environment.get_user_config_dir (), Strings.APPLICATION_ID);
                File.new_for_path (config_dir).make_directory ();
            } catch (Error error) {
                if (error.code != IOError.EXISTS) {
                    critical ("%s: %d: %s\n", Strings.APPLICATION_ERROR_CONFIG_CREATE, error.code, error.message);
                    string error_config_create_msg = Strings.APPLICATION_ERROR_CONFIG_CREATE;
                    show_fatal_dialog (Strings.APPLICATION_ERROR_INIT_FAILED, error_config_create_msg + ".\n\n" + error.message + ".");
                }
            }

            background_history_file = "%s/previous_backgrounds.cfg".printf (config_dir);
            try {
                File.new_for_path (background_history_file).create (FileCreateFlags.NONE);
            } catch (Error error) {
                if (error.code != IOError.EXISTS) {
                    warning ("%s: %d: %s\n", Strings.APPLICATION_ERROR_CONFIG_BACKGROUND_CREATE, error.code, error.message);
                    string error_config_background_create_msg = Strings.APPLICATION_ERROR_CONFIG_BACKGROUND_CREATE;
                    show_warning_dialog (Strings.APPLICATION_ERROR_INIT_FAILED, error_config_background_create_msg + ".\n\n" + error.message + ".");
                }
            }

            image_providers.add (new BingImageProvider ());

            _background_change_handler = new BackgroundChangeHandler (image_providers);
            _image_refresh_handler = new ImageRefreshHandler (image_providers);

            application_settings.changed.connect ((key) => {
                switch (key) {
                case Strings.APPLICATION_SETTINGS_BACKGROUND_CHANGE_INTERVAL :
                    _background_change_handler.update_background_change_interval ();
                    break;
                case Strings.APPLICATION_SETTINGS_STARTUP_SET_LATEST :
                    break;
                case Strings.APPLICATION_SETTINGS_DONT_REUSE_OLD_WALLPAPERS :
                    break;
                case Strings.APPLICATION_SETTINGS_REFRESH_INTERVAL :
                    _image_refresh_handler.update_refresh_interval ();
                    break;
                case Strings.APPLICATION_SETTINGS_ENABLE_NOTIFICATIONS :
                    break;
                case Strings.APPLICATION_SETTINGS_KEEP_RUNNING_WHEN_CLOSED  :
                    break;
                }
            });

            _main_window = new MainWindow ();
            _main_window.show_all ();
            add_window (_main_window);
        }
    }

    public static int main (string[] args) {
        print ("FLATPAK_ID: %s\n", Environment.get_variable ("FLATPAK_ID"));
        print ("container: %s\n",  Environment.get_variable ("container"));

        TapetError.quark = Quark.from_string (Strings.APPLICATION_ERROR_QUARK);

        instance = new TapetApplication ();
        return instance.run (args);
    }
}
