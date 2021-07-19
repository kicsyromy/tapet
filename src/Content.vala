/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class Content : Gtk.Box {
    public Content () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 12
            ) ;

    }

    construct {
        load_thumbnails.begin (this, (_, res) => {
            load_thumbnails.end (res) ;
        }) ;
    }

    private static async void load_thumbnails(Gtk.Container container) {
        var image_providers = TapetApplication.instance.image_providers.data ;

        foreach( var image_provider in image_providers ){
            try {
                var urls = yield image_provider.get_image_urls(image_provider.max_image_count (), ImageQuality.LOW) ;

                foreach( var url in urls ){
                    var pixbuf = yield new Gdk.Pixbuf.from_stream_async (yield Utilities.get_stream_async (url)) ;

                    var image = new Gtk.Image.from_pixbuf (pixbuf) ;
                    image.set_visible (true) ;

                    container.add (image) ;
                }
            } catch ( Error error ) {
                printerr ("Failed to download images from provider '%s': %d: %s\n", image_provider.name (), error.code, error.message) ;
            }

        }
    }

}