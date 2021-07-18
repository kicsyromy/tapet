/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

public class TapetApplication : Gtk.Application {
    public static TapetApplication instance = null ;

    internal GenericArray<ImageProvider> image_providers = new GenericArray<ImageProvider>() ;
    internal string cache_dir ;

    public TapetApplication () {
        Object (
            application_id: Strings.APPLICATION_ID,
            flags : ApplicationFlags.FLAGS_NONE
            ) ;
    }

    protected override void activate() {
        add_window (new MainWindow ()) ;
    }

    public static int main(string[] args) {
        instance = new TapetApplication () ;

        TapetError.quark = Quark.from_string (Strings.APPLICATION_ERROR_QUARK) ;

        instance.image_providers.add (new BingImageProvider ()) ;

        try {
            instance.cache_dir = Environment.get_user_cache_dir () + "/" + Strings.APPLICATION_ID ;
            File.new_for_path (instance.cache_dir).make_directory () ;
        } catch ( Error error ) {
            if( error.code != IOError.EXISTS ){
                printerr ("Failed to create cache directory: %d: %s\n", error.code, error.message) ;
            }
        }

        instance.startup.connect (() => {
            Hdy.init () ;
        }) ;

        return instance.run (args) ;
    }

}

