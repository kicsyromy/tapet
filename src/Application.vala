/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

public class TapetApplication : Gtk.Application {
    public static TapetApplication instance = null;

    internal static SystemSettings system_settings = new SystemSettings ();

    internal GenericArray<ImageProvider> image_providers = new GenericArray<ImageProvider>();
    internal string cache_dir;

    public TapetApplication () {
        Object (
            application_id: Strings.APPLICATION_ID,
            flags : ApplicationFlags.FLAGS_NONE
            );
    }

    public static void show_fatal_dialog (string primary_text, string secondary_text) {
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            primary_text, secondary_text,
            "dialog-error",
            Gtk.ButtonsType.NONE
            );

        ((Gtk.Button)message_dialog.add_button (Strings.MISC_QUIT, Gtk.ResponseType.OK))
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

        ((Gtk.Button)message_dialog.add_button (Strings.MISC_CLOSE, Gtk.ResponseType.OK))
            .get_style_context ()
            .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        message_dialog.run ();
        message_dialog.destroy ();
    }

    protected override void activate () {
        add_window (new MainWindow ());
    }

    private async void init () {
        try {
            instance.cache_dir = Environment.get_home_dir () + "/.cache/" + Strings.APPLICATION_ID;
            File.new_for_path (instance.cache_dir).make_directory ();
        } catch (Error error) {
            if (error.code != IOError.EXISTS) {
                critical ("%s: %d: %s\n", Strings.APPLICATION_ERROR_CACHE_CREATE, error.code, error.message);
                string error_cache_create_msg = Strings.APPLICATION_ERROR_CACHE_CREATE;
                show_fatal_dialog (Strings.APPLICATION_ERROR_INIT_FAILED, error_cache_create_msg + ". " + error.message + ".");
            }
        }
    }

    public static int main (string[] args) {
        print ("FLATPAK_ID: %s\n", Environment.get_variable ("FLATPAK_ID"));
        print ("container: %s\n",  Environment.get_variable ("container"));

        instance = new TapetApplication ();

        TapetError.quark = Quark.from_string (Strings.APPLICATION_ERROR_QUARK);

        instance.image_providers.add (new BingImageProvider ());

        instance.startup.connect (() => {
            Hdy.init ();
            instance.init.begin ((_, res) => {
                instance.init.end (res);
            });
        });

        return instance.run (args);
    }
}
