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

    private MainWindow _main_window = null;
    private ImageRefreshHandler _image_refresh_handler = null;

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
                    show_fatal_dialog (Strings.APPLICATION_ERROR_INIT_FAILED, error_cache_create_msg + ". " + error.message + ".");
                }
            }

            image_providers.add (new BingImageProvider ());

            _image_refresh_handler = new ImageRefreshHandler (image_providers);
            set_up_image_refresh_handler ();

            _main_window = new MainWindow ();
            add_window (_main_window);
        }
    }

    private void set_up_image_refresh_handler () {
        var refresh_interval = application_settings.get_string (Strings.APPLICATION_SETTINGS_REFRESH_INTERVAL).split ("|")[1];
        var refresh_interval_ms = 12 * 60 * 60000;
        switch (refresh_interval)
        {
        default :
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_1_MINUTE :
            refresh_interval_ms = 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_5_MINUTES :
            refresh_interval_ms = 5 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_10_MINUTES :
            refresh_interval_ms = 10 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_15_MINUTES :
            refresh_interval_ms = 10 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_30_MINUTES :
            refresh_interval_ms = 30 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_1_HOUR :
            refresh_interval_ms = 60 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_2_HOURS :
            refresh_interval_ms = 2 * 60 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_4_HOURS :
            refresh_interval_ms = 4 * 60 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_6_HOURS :
            refresh_interval_ms = 6 * 60 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_12_HOURS :
            refresh_interval_ms = 12 * 60 * 60000;
            break;
        case Strings.SETTINGS_COMBO_BOX_INTERVAL_1_DAY :
            refresh_interval_ms = 24 * 60 * 60000;
            break;
        }
        _image_refresh_handler.set_interval (refresh_interval_ms);
        _image_refresh_handler.start ();
    }

    public static int main (string[] args) {
        print ("FLATPAK_ID: %s\n", Environment.get_variable ("FLATPAK_ID"));
        print ("container: %s\n",  Environment.get_variable ("container"));

        TapetError.quark = Quark.from_string (Strings.APPLICATION_ERROR_QUARK);

        instance = new TapetApplication ();
        return instance.run (args);
    }
}
