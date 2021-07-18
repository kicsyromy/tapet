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
        download_images.begin ((_, res) => {
            var thumbnails = download_images.end (res) ;

            foreach( var thumbnail in thumbnails.data ){
                var image = new Gtk.Image.from_file (thumbnail) ;
                image.set_visible (true) ;
                pack_start (image, false, false, 12) ;
            }
        }) ;
    }

    private static async GenericArray<string> download_images() {
        var result = new GenericArray<string>() ;

        var image_providers = TapetApplication.instance.image_providers.data ;

        foreach( var image_provider in image_providers ){
            try {
                var urls = yield image_provider.get_image_urls(image_provider.max_image_count (), ImageQuality.LOW) ;

                foreach( var url in urls ){
                    result.add (yield image_provider.save (url, TapetApplication.instance.cache_dir, "thumb_")) ;

                }

            } catch ( Error error ) {
                printerr ("Failed to download images from provider '%s': %d: %s\n", image_provider.name (), error.code, error.message) ;
            }
        }

        return result ;
    }

}