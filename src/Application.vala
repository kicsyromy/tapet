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

        instance.image_providers.add (new BingImageProvider ()) ;
        instance.cache_dir = Environment.get_home_dir () + "/.cache/" + Strings.APPLICATION_ID ;

        instance.startup.connect (() => {
            Hdy.init () ;

            instance.image_providers.data[0].get_image_urls.begin (8, ImageQuality.HIGH, (_, res) => {
                try {
                    var image_urls = instance.image_providers.data[0].get_image_urls.end (res) ;

                    foreach( var url in image_urls ){
                        print ("%s\n", url) ;
                    }
                } catch ( Error error ) {
                    printerr ("Failed to get image urls: %d: %s\n", error.code, error.message) ;
                }

            }) ;
        }) ;

        return instance.run (args) ;
    }

}

